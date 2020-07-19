//
//  LearnMoreViewController.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit
import WebKit

class LearnMoreViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        
        return view
    }()
    
    var html: String?
    
    override func loadView() {
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.html ?? "") {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
