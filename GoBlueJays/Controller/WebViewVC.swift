//
//  WebViewVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 10/17/22.
//

import Foundation
import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    var link:String = ""
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        guard let url = URL(string: link) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

