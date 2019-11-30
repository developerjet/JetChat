//
//  WkWebBrowserViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/4/14.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SnapKit

class WkWebBrowserViewController: FYBaseConfigViewController {
    
    var url: String?
    
    // MARK:- Lazy var
    
    lazy var wkWebView: FYConfiguraWebView = {
        let web = FYConfiguraWebView(isSnapLayout: true)
        web.isShowRefresh = true
        web.isShowProgress = true
        web.delegate = self
        web.url = self.url!
        return web
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.textAlignment = .right
        button.contentHorizontalAlignment = .right
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        button.setTitleColor(UIColor.colorWithHexStr("111111"), for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        //button.setTitle(Lca.sb_e_mine_feedback_new.rLocalized(), for: .normal)
        //button.addTarget(self, action: #selector(addFeedback), for: .touchUpInside)
        return button
    }()
    
    // MARK: - init
    
    init(url: String = "") {
        super.init(nibName:nil, bundle:nil)
        
        guard url.length > 0 else {
            return
        }
        
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavShadowImage = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 禁止侧滑返回手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeLayout()
    }

    override func makeUI() {
        super.makeUI()
        view.backgroundColor = .backGroundWhiteColor()
        view.addSubview(wkWebView)
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK:- FYWebMessageHandlerDelegate

extension WkWebBrowserViewController: FYConfigWebViewDelegate {
    
    func webViewDidMessageHandler(_ webView: FYConfiguraWebView, message: WkHandlerMessage) {
//        if let type = model.type {
//            if let jsCallType = JavaScriptCallType(rawValue: type) {
//
//            }
//        }
    }
}

