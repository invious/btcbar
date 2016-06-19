//
//  QuotesViewController.swift
//  traymenu_tutorial
//
//  Created by Aymon Fournier on 6/17/16.
//  Copyright © 2016 Aymon Fournier. All rights reserved.
//

import Cocoa
import WebKit

class QuotesViewController: NSViewController {
    @IBOutlet var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "https://bitcoinity.org/markets?theme=dark");
        let requestObj = NSURLRequest(URL: url!);
        webView.mainFrame.loadRequest(requestObj)

    }
    

}

