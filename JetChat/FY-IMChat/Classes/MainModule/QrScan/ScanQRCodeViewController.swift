//
//  ScanQRCodeViewController.swift
//  JChat
//
//  Created by JIGUANG on 2017/8/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: UIViewController {
    
    final let borderW = CGFloat(240)
    final let borderY = (UIScreen.main.bounds.size.height - 240) * 0.5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "扫一扫".rLocalized()
        view.backgroundColor = .white
        
        self.extendedLayoutIncludesOpaqueBars = true;
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        if(authStatus == .restricted || authStatus == .denied){
            let alertView = UIAlertView(title: "无法访问相机", message: "请在设备的设置-趣阅中允许访问相机。",delegate: self, cancelButtonTitle: "好的", otherButtonTitles: "去设置")
            alertView.show()
            return;
        }
        
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        session.startRunning()
        
        let borderView = UIImageView(frame: CGRect(x: (view.width - borderW) / 2, y: borderY, width: borderW, height: borderW))
        borderView.image = UIImage(named: "icon_qrc_border")
        view.addSubview(borderView)
        
        qrcLine = UIImageView(frame: CGRect(x: (view.width - 190) / 2, y: borderY, width: 190, height: 6))
        qrcLine.image = UIImage(named: "icon_qrc_line")
        view.addSubview(qrcLine)

        let imageView = UIImageView(frame: view.frame)
        imageView.image = _getBackgroundImage()
        view.addSubview(imageView)
        
        let tipsLabel = UILabel(frame: CGRect(x: 10, y: borderY + borderW + 17.5, width: view.width - 20, height: 20))
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        tipsLabel.text = "将取景框对准二维码，即可自动扫描".rLocalized()
        tipsLabel.textColor = .appThemeHexColor()
        tipsLabel.textAlignment = .center
        tipsLabel.numberOfLines = 2
        view.addSubview(tipsLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startQRCAnimate), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    var qrcLine: UIImageView!
    var isStopAnimate = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.startRunning()
        isStopAnimate = false
        isAnimating = false
        startQRCAnimate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x2dd0cf)
        self.qrcLine.layer.removeAllAnimations()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate lazy var session: AVCaptureSession = {
        var session = AVCaptureSession()
        var device = AVCaptureDevice.default(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            print(error)
        }
        if input != nil {
            session.addInput(input!)
        }
        var output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        return session
    }()
    
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        var previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        return previewLayer
    }()
    
    private func _getBackgroundImage() -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        ctx.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let screenSize = UIScreen.main.bounds.size
        var drawRect = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        ctx.fill(drawRect)
        drawRect = CGRect(x: (view.width - borderW) / 2, y: borderY, width: borderW, height: borderW)
        ctx.clear(drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var isAnimating = false
    
    @objc func startQRCAnimate() {
        if isStopAnimate || isAnimating {
            return
        }
        isAnimating = true
        qrcLine.frame = CGRect(x: (self.view.width - 190) / 2, y: borderY, width: 190, height: 6)
        UIView.animate(withDuration: 2.5, animations: {
            self.qrcLine.frame = CGRect(x: (self.view.width - 190) / 2, y: self.borderY + self.borderW - 5, width: 190, height: 6)
        }) { (finish) in
            self.isAnimating = false
            self.qrcLine.frame = CGRect(x: (self.view.width - 190) / 2, y: self.borderY, width: 190, height: 6)
            if finish {
                self.startQRCAnimate()
            }
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadataObject in metadataObjects {
            guard let object = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            let barCodeObject = previewLayer.transformedMetadataObject(for: object)
            let frame = barCodeObject!.bounds
            
            let validFrame = CGRect(x: (view.width - borderW) / 2, y: borderY, width: borderW, height: borderW)
            if frame.origin.x < validFrame.origin.x || frame.origin.x + frame.size.width > validFrame.origin.x + validFrame.size.width {
                return
            }
            
            if frame.size.width > validFrame.size.width {
                return
            }
            
            if frame.origin.y < validFrame.origin.y || frame.origin.y + frame.size.height > validFrame.origin.y + validFrame.size.height {
                return
            }
            
            if frame.size.height > validFrame.size.height {
                return
            }
            
            if object.type.rawValue == convertFromAVMetadataObjectObjectType(AVMetadataObject.ObjectType.qr) {
                guard let url = object.stringValue else {
                    return
                }
                
                if let openURL = URL(string: url) {
                    if UIApplication.shared.canOpenURL(openURL) {
                        UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
                    } else {
                        guard let safeURL = URL(string: "https://" + url) else {
                            return
                        }
                        
                        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)
                    }
                    return
                }
            
                let jsonData: Data = url.data(using: .utf8)!

                let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                guard let info = dict as? NSDictionary else {
                    return
                }

                session.stopRunning()
            }
        }
    }
    

    func convertStringToDictionary(text: String) -> [String : AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

extension ScanQRCodeViewController: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMetadataObjectObjectType(_ input: AVMetadataObject.ObjectType) -> String {
	return input.rawValue
}
