//
//  FYFileSizeManager.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import Kingfisher
import YBImageBrowser
import SDWebImage

class FYFileSizeManager: NSObject {

    static let manager = FYFileSizeManager()
    
    /// 显示缓存大小
    public func cacheSize() -> String {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else { return "0M" }
        return String(format: "%.2fM", folderSize(filePath: cachePath))
    }
    
    
    /// 计算单个文件的大小
    public func fileSize(filePath: String) -> UInt64 {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                let attr = try manager.attributesOfItem(atPath: filePath)
                let size = attr[FileAttributeKey.size] as! UInt64
                return size
            } catch  {
                print("error :\(error)")
                return 0
            }
        }
        return 0
    }
    
    
    /// 遍历文件夹，返回多少M
    public func folderSize(filePath: String) -> CGFloat {
        let folderPath = filePath as NSString
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            let childFilesEnumerator = manager.enumerator(atPath: filePath)
            var fileName = ""
            var folderSize: UInt64 = 0
            while childFilesEnumerator?.nextObject() != nil {
                guard let nextObject = childFilesEnumerator?.nextObject() as? String else {
                    return 0
                }
                fileName = nextObject
                let fileAbsolutePath = folderPath.strings(byAppendingPaths: [fileName])
                folderSize += fileSize(filePath: fileAbsolutePath[0])
            }
            return CGFloat(folderSize) / (1024.0 * 1024.0)
        }
        
        return 0
    }
    
    
    /// 清除缓存
    func clearCache() {
        let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let files = FileManager.default.subpaths(atPath: cachPath as String)
        for p in files! {
            let path = cachPath.appendingPathComponent(p)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }

    /// 删除沙盒里的文件
    public func deleteFile(filePath: String) {
        let manager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let uniquePath = path.appendingPathComponent(filePath)
        if manager.fileExists(atPath: uniquePath) {
            do {
                try FileManager.default.removeItem(atPath: uniquePath)
            } catch {
                print("error:\(error)")
            }
        }
    }

    
    /// 获取图片缓存
    public func imageCacheSize( _ callback: @escaping (String) -> ()) {
        let cache = ImageCache.default
        cache.diskStorage.config.sizeLimit = UInt(200 * 1024 * 1024)
        cache.diskStorage.config.expiration = .days(15)
        cache.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                var dataSize : String{
                    guard size >= 1024 else { return "\(size)bytes" }
                    guard size >= 1048576 else { return "\(size / 1024)K" }
                    guard size >= 1073741824 else { return "\(size / 1048576)M" }
                    return "\(size / 1073741824)G"
                }
                callback(dataSize)
                
            case .failure(let error):
                print("统计图片缓存失败", error)
                callback("0M")
            }
        }
    }
    
    /// 清除图片缓存
    public func clearImageCaches(completion handler: (()->())?) {
        clearCache()
        
        SDImageCachesManager.shared.clear(with: .all) {
            handler?()
        }
    
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()//清理网络缓存
        cache.cleanExpiredDiskCache()//清理过期的，或者超过硬盘限制大小的
        cache.clearDiskCache {
            handler?()
        }
    }
}
