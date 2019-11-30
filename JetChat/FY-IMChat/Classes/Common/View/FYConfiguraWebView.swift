//
//  SBConfiguraWebView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/6/6.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import SnapKit


/// 回调代理方法
protocol FYConfigWebViewDelegate {
    /// 加载url完成
    func webViewDidFinish(_ webView: FYConfiguraWebView, didFinish navigation: WKNavigation)
    /// 加载url失败
    func webViewDidFailure(_ webView: FYConfiguraWebView, didFail navigation: WKNavigation, withError error: Error)
    /// 通过与js注册的方法相应回调
    func webViewDidMessageHandler(_ webView: FYConfiguraWebView, message: WkHandlerMessage)
}

// 实现可选协议
extension FYConfigWebViewDelegate {
    func webViewDidFinish(_ webView: FYConfiguraWebView, didFinish navigation: WKNavigation) {}
    func webViewDidFailure(_ webView: FYConfiguraWebView, didFail navigation: WKNavigation, withError error: Error) {}
    func webViewDidMessageHandler(_ webView: FYConfiguraWebView, message: WkHandlerMessage) {}
}

class FYConfiguraWebView: UIView {
    
    // MARK: - var
    
    private var isSnapLayout: Bool = false
    
    /// 设置代理
    var delegate: FYConfigWebViewDelegate?
    
    /// 加载的url
    var url: String? {
        didSet {
            guard url?.isEmpty == false else {
                return
            }
            
            loadRequest(url ?? "")
        }
    }
    
    /// 是否显示进度条
    var isShowProgress: Bool = true {
        didSet {
            self.progressView.isHidden = !isShowProgress
        }
    }
    
    /// 是否添加下拉刷新
    var isShowRefresh: Bool = false {
        didSet {
            if isShowRefresh == true {
                makeRefresh()
            }
        }
    }
    
    /// 是否额外拉伸
    var isBounces: Bool = true {
        didSet {
            if isBounces == false {
                self.wkWebView.scrollView.bounces = false
            }
        }
    }
    
    /// 是否能返回上级
    var isCanGoBack: Bool? {
        get {
            if self.wkWebView.canGoBack {
                return true
            }
            return false
        }
    }
    
    // MARK:- Lazy
    
    lazy var wkWebView: WKWebView = {
        // 创建配置
        let config = WKWebViewConfiguration()
        // 将UserConttentController设置到配置文件
        config.preferences.javaScriptEnabled = true
        config.selectionGranularity = .character
        config.processPool = WKProcessPool.init()
        // 设置web多语言
        if let language = LanguageManager.manager.selectedLanguage?.localizedStr() {
            //let js = "var App = {\"getAppLanguage\":function(){return \(language)}}"
            let js = "getIOSLanguage('\(language)')"
            let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            config.userContentController.addUserScript(script)
        }
        // 传入token
        if let token = UserInfoManager.shared.userInfo?.token {
            //let js = "var App = {\"getAppToken\":function(){return \(token)}}"
            let js = "getAppToken('\(token)')"
            let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            config.userContentController.addUserScript(script)
        }
        config.userContentController.add(self, name: "callAppSBlockMethod")
        config.userContentController.add(self, name: "callAppBackMethod")
        
        // 自定义配置创建WKWebView
        let webView = WKWebView(frame: self.bounds, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let width = self.width
        let height = kFitScale(AT: 10)
        let prgView = UIProgressView(frame: CGRect(x: 0, y: 0.1, width: width, height: height))
        prgView.alpha = 0.0
        prgView.progress = 0.0
        prgView.isHidden = true //默认隐藏
        prgView.trackTintColor = UIColor.clear
        prgView.backgroundColor = UIColor.clear
        prgView.progressTintColor = UIColor.random
        return prgView
    }()
    
    // MARK:- Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    convenience init(isSnapLayout: Bool = true) {
        self.init(frame: CGRect.zero)
        self.isSnapLayout = isSnapLayout
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        addSubview(wkWebView)
        addSubview(progressView)
    }
    
    func makeLayout() {
        
        if isSnapLayout == true {
            progressView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(0.1)
                make.height.equalTo(kFitScale(AT: 2.0))
            }
            
            wkWebView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func loadRequest(_ URLString: String) {
        guard URLString.length > 0 else {
            return
        }
        
        if (URLString.hasPrefix("http")) {
            if let url = URLString.URLValue {
                let request = URLRequest(url: url)
                wkWebView.load(request)
            }
        }else {
            // html
            wkWebView.loadHTMLString(URLString, baseURL: nil)
        }
    }
    
    /// 添加下拉刷新
    func makeRefresh() {
        if isShowRefresh == true {
            self.wkWebView.scrollView.bindHeadRefreshHandler({ [weak self] in
                guard let self = self else { return }
                if self.wkWebView.scrollView.headRefreshControl.isTriggeredRefreshByUser == false {
                    if (self.wkWebView.isLoading == false) {
                        self.wkWebView.reload()
                    }
                }
                }, themeColor: UIColor.appThemeHexColor(), refreshStyle: KafkaRefreshStyle.replicatorCircle)
        }
    }
    
    /// 主动执行下拉刷新
    func shouldRefresh() {
        if (self.wkWebView.isLoading == false) {
            self.wkWebView.reload()
        }
    }
    
    /// 返回上级页面
    func goBack() {
        if self.isCanGoBack == true {
            self.wkWebView.goBack()
        }
    }
    
    
    // MARK:- KVO estimatedProgress
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 设置进度
        if keyPath == "estimatedProgress" && ((object as? WKWebView) != nil) {
            progressView.alpha = 1.0
            progressView.setProgress(Float(self.wkWebView.estimatedProgress), animated: true)
            if self.wkWebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0.0
                }) { (finished) -> Void in
                    self.progressView.setProgress(0.0, animated: true)
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        if (self.isProxy()) {
            wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
            wkWebView.configuration.userContentController.removeAllUserScripts()
            // 清除url缓存
            URLCache.shared.removeAllCachedResponses()
        }
        
        if (wkWebView.navigationDelegate != nil) {
            wkWebView.navigationDelegate = nil
        }
        
        if (wkWebView.uiDelegate != nil) {
            wkWebView.uiDelegate = nil
        }
    }
}


// MARK:- WKNavigationDelegate

extension FYConfiguraWebView: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isShowRefresh == true {
            if wkWebView.scrollView.headRefreshControl.isTriggeredRefreshByUser == false {
                wkWebView.scrollView.headRefreshControl.endRefreshing()
            }
        }
        
        delegate?.webViewDidFinish(self, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if isShowRefresh == true {
            if wkWebView.scrollView.headRefreshControl.isTriggeredRefreshByUser == false {
                wkWebView.scrollView.headRefreshControl.endRefreshing()
            }
        }
        
        delegate?.webViewDidFailure(self, didFail: navigation, withError: error)
    }
}

// MARK:- WKScriptMessageHandler

extension FYConfiguraWebView: WKScriptMessageHandler {
    /// 接收js调用方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callAppSBlockMethod" {
            if let bodyString = JSON(message.body).string {
                javaScriptMessageCallback(bodyString)
            }
        }
    }
    
    // 处理js回调的返回值
    func javaScriptMessageCallback(_ object: String) {
        guard object.isEmpty == false else {
            return
        }
        
        // 注意放到主线程
        DispatchQueue.main.async {
            if let dictionary = JSON(String().getDictionaryFromJSONString(object)).dictionaryObject {
                if let model = WkHandlerMessage.deserialize(from: dictionary) {
                    self.delegate?.webViewDidMessageHandler(self, message: model)
                }
            }
        }
    }
}

