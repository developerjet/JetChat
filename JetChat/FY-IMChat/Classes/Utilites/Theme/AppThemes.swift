//
//  AppThemes.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/10/11.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import SwiftTheme


enum AppThemes: Int {
    
    case light = 1
    case night = 2
    
    // MARK: - var lazy
    
    static var current = AppThemes.light
    
    // MARK: - Switch Theme
    
    static func switchTo(_ theme: AppThemes = .light) {
        current = AppThemes(rawValue: theme.rawValue)!
        
        switch theme {
            case .light :
                ThemeManager.setTheme(plistName: "Light", path: .mainBundle)
                break
            case .night :
                ThemeManager.setTheme(plistName: "Night", path: .mainBundle)
                break
        }
        
        // status bar
        UIApplication.shared.theme_setStatusBarStyle("UIStatusBarStyle", animated: true)
        
        UserDefaults.standard.set(theme.rawValue, forKey: kThemeSettingUserDefaultKey)
        UserDefaults.standard.synchronize()
    }
    
    static func lastSetedTheme() -> AppThemes {
        if let lastTheme = UserDefaults.standard.object(forKey: kThemeSettingUserDefaultKey) as? Int {
            return AppThemes(rawValue: lastTheme)!
        }
        
        return AppThemes.light
    }
    
    static func switchToNext() {
        var next = current.rawValue + 1
        var max  = 2 // without Blue and Night
        
        if isBlueThemeExist() { max += 1 }
        if next >= max { next = 0 }
        
        switchTo(AppThemes(rawValue: next)!)
    }
    
    // MARK: - Switch Night
    
    static func switchNight(_ isToNight: Bool) {
        switchTo(isToNight ? .night : .light)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
    
    // MARK: - Download
    
    static func downloadBlueTask(_ handler: @escaping (_ isSuccess: Bool) -> Void) {
        
        let session = URLSession.shared
        let url = "https://github.com/wxxsw/SwiftThemeResources/blob/master/20170128/Blue.zip?raw=true"
        let URL = Foundation.URL(string: url)
        
        let task = session.downloadTask(with: URL!, completionHandler: { location, response, error in
            
            guard let location = location , error == nil else {
                DispatchQueue.main.async {
                    handler(false)
                }
                return
            }
            
            let manager = FileManager.default
            let zipPath = cachesURL.appendingPathComponent("Blue.zip")
            
            _ = try? manager.removeItem(at: zipPath)
            _ = try? manager.moveItem(at: location, to: zipPath)
            
            let isSuccess = SSZipArchive.unzipFile(atPath: zipPath.path,
                                        toDestination: unzipPath.path)
            
            DispatchQueue.main.async {
                handler(isSuccess)
            }
        })
        
        task.resume()
    }
    
    static func isBlueThemeExist() -> Bool {
        return FileManager.default.fileExists(atPath: blueDiretory.path)
    }
    
    static let blueDiretory : URL = unzipPath.appendingPathComponent("Blue/")
    static let unzipPath    : URL = libraryURL.appendingPathComponent("Themes/20170128")
    
}
