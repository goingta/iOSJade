//
//  WKWebViewController.swift
//  iOSJade
//
//  Created by goingta on 2018/12/25.
//  Copyright © 2018 goingta. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    var webUrlString: String!

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(webUrlString != nil, "webUrlString不能为空")
        self.initUI()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() {
        let config = WKWebViewConfiguration.init()
        let controller = WKUserContentController.init()
        controller.add(self, name: "hybridHandle")
        config.userContentController = controller
        webView = WKWebView.init(frame: self.view.frame, configuration: config)
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.navigationDelegate = self

        if let url = URL.init(string: webUrlString) {
            webView.load(URLRequest.init(url: url))
        }
        
//        self.view.addSubview(webView)
        self.view.backgroundColor = UIColor.red
        
        let item = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(refresh))
        self.tabBarController?.navigationItem.rightBarButtonItem = item
        //        self.navigationItem.rightBarButtonItem = item
        
        self.navigationController?.setNeedsNavigationBackground(alpha: 0)
    }

    @objc func refresh() {
        webView.reload()
    }

}

extension WKWebViewController:WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let title = NSLocalizedString("OK", comment: "OK Button")
        let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        present(alert, animated: true)
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if url?.scheme == "gtahybrid", let host = url?.host {
//            if host == "action",let dic = url?.query?.urlParametersToDic {
//                let result = self.execute(dic: dic)
//                print("execute \(result)")
//                decisionHandler(.cancel)
//                return
//            }
        }
        decisionHandler(.allow)
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case "hybridHandle":
            //多个参数
            if let dic = message.body as? NSDictionary {
//                let result = self.execute(dic: dic)
//                print("execute \(result)")
            }
        default: break
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail")
        print(error)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 100 {
            self.navigationController?.setNeedsNavigationBackground(alpha: 1)
        } else {
            self.navigationController?.setNeedsNavigationBackground(alpha: 0)
        }
    }

}

