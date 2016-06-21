//
//  QuotesViewController.swift
//  traymenu_tutorial
//
//  Created by Aymon Fournier on 6/17/16.
//  Copyright © 2016 Aymon Fournier. All rights reserved.
//

import Cocoa
import WebKit

class QuotesViewController: NSViewController, WebFrameLoadDelegate {
    @IBOutlet var webView: WebView!
    
    override func viewDidAppear() {
        super.viewDidLoad()
        
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        
        
        let url = appearance == "Light" ? NSURL (string: "https://bitcoinity.org/markets?theme=light") : NSURL (string: "https://bitcoinity.org/markets?theme=dark")
        let requestObj = NSURLRequest(URL: url!);
        
        webView.shouldUpdateWhileOffscreen = false
        webView.frame=self.view.bounds;
        webView.frameLoadDelegate = self
        webView.mainFrame.loadRequest(requestObj)

    }
    
    func webView(sender: WebView, didFinishLoadForFrame frame: WebFrame) {
        //get the scroll view that contains the frame contents
        var scrollView: NSScrollView = webView.mainFrame.frameView.documentView.enclosingScrollView!
        
        scrollView.hasHorizontalScroller = true
    }
    

}

