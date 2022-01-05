//
//  WebController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/4.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import WebKit

class WebController: BaseController, WKUIDelegate, WKNavigationDelegate {

    var url: String?
    private var webView: WKWebView?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if webView == nil {
            return
        }
        webView?.load(URLRequest.init(url: URL.init(string: "about:blank")!))
        CBToast.hiddenToastAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = tableView.frame
        tableView.removeFromSuperview()
        edgesForExtendedLayout = .bottom
        let config = WKWebViewConfiguration.init()
        config.allowsInlineMediaPlayback = true
        webView = WKWebView.init(frame: frame, configuration: config)
        webView!.uiDelegate = self
        webView!.navigationDelegate = self
        view.addSubview(webView!)
        
        webView!.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.left()?.right()?.bottom()?.offset()(0)
        }
        
        if url?.count == 0 {
            CBToast.hiddenToastAction()
            CBToast.showToastAction(message: "加载失败")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.leftBtnClicked()
            }
            return
        }
        let request = URLRequest.init(
            url: URL.init(string: url!)!,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 30
        )
        webView!.load(request)
        print("url: %s", url ?? "")
    }
    
    //    MARK: webview delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        CBToast.showToastAction()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CBToast.hiddenToastAction()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CBToast.hiddenToastAction()
        CBToast.showToastAction(message: "加载失败")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.leftBtnClicked()
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        CBToast.hiddenToastAction()
        CBToast.showToastAction(message: "加载失败")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.leftBtnClicked()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let description = navigationAction.request.url?.description
        if description == nil {
            decisionHandler(.allow);
            return
        }

        if !description!.hasPrefix("sdk:") {
            decisionHandler(.allow)
            return
        }

        let value = description!.suffix(1)
        print("shouldStartLoadWith: value: %s", value)
        if value == "1" {
            pushIndexController()
        } else {
            pushOrderController()
        }
        decisionHandler(.cancel)
    }
    
    //    MARK: 跳转到首页
    private func pushIndexController() {
        LoginTool.getTabController().pushIndexController()
    }
    
    private func pushOrderController() {
        LoginTool.getTabController().pushOrderController()
    }
}
