//
//  ViewController.swift
//  STOCKer
//
//  Created by 신지원 on 6/10/24.
//

import UIKit
import WebKit

import SnapKit

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate{
    
    let baseURL = "https://stocker-client-vercel.vercel.app/"
    var webView: WKWebView!
    
    override func loadView() {
        
        controlView()
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    private func controlView() {
        let mainView = UIView()
        view = mainView
        
        // 확대 방지를 위한 JavaScript 코드
        let source = """
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                var head = document.getElementsByTagName('head')[0];
                head.appendChild(meta);
                """
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    private func setView() {
        if let url = URL(string: baseURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension ViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading: \(String(describing: webView.url))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
    }
}

