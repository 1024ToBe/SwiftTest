//
//  JLBaseWebVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit
import WebKit
class JLBaseWebVC: JLBaseVC {

    @IBOutlet weak var wkView: WKWebView!
    var urlStr :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL(string: "http://m.a05f.com/" + urlStr)
        let request = NSURLRequest(url: url! as URL)
        wkView.navigationDelegate = self
        wkView.load(request as URLRequest)
    }
    
}

extension JLBaseWebVC: WKNavigationDelegate, WKUIDelegate {
    //页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delog("[BaseWebView] 开始加载")
    }
    
    //监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        delog("[BaseWebView] 加载进行中")
    }
    
    //当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delog("[BaseWebView] 开始返回时调用")
    }
    
    //页面加载完毕调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delog("[BaseWebView] 加载完毕")
    }
    
    //页面加载失败后调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delog("[BaseWebView] 加载失败！")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        delog("[BaseWebView] 加载失败原因是 \(error.localizedDescription)")
    }
    
    
}
