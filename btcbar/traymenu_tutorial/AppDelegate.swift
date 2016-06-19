//
//  AppDelegate.swift
//  traymenu_tutorial
//
//  Created by Aymon Fournier on 6/17/16.
//  Copyright © 2016 Aymon Fournier. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let statusBarMenu = NSMenu(title: "Loading")
    let optionsMenuButton = NSMenuItem.init(title: "Options", action: #selector(AppDelegate.toggleOptionsPopover(_:)), keyEquivalent: "")
    @IBOutlet weak var window: NSWindow!
    var eventMonitor: EventMonitor?
    var updateDataTimer = NSTimer()
    var responseData : NSMutableData?
    var ticker = ""
    
    let bitcoinityPopover = NSPopover()
    let optionsPopover = NSPopover()


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusBarMenu.addItem(NSMenuItem.init(title: "Bitcoinity", action: #selector(AppDelegate.toggleBitcoinityPopover(_:)), keyEquivalent: ""))
        statusBarMenu.addItem(NSMenuItem.separatorItem())
        statusBarMenu.addItem(optionsMenuButton)
        statusBarMenu.addItem(NSMenuItem.init(title: "Quit", action: #selector(AppDelegate.quit(_:)), keyEquivalent: "q"))

        
        statusItem.menu = statusBarMenu
        
        //Set the status menu bar item to bitcoin price
        
        
        bitcoinityPopover.contentViewController = QuotesViewController(nibName: "QuotesViewController", bundle: nil)
        
        optionsPopover.contentViewController = OptViewController(nibName: "OptViewController", bundle: nil)
        
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) {
            [unowned self] event in
            if self.bitcoinityPopover.shown {
                self.closePopover(event)
            }
            
            if self.optionsPopover.shown {
                self.closeOptionsPopover(event)
            }
        }
        eventMonitor?.start()
        
        setRefreshRate(120)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func setRefreshRate(rate: Int32){
        let rateInSecs = rate * 60
        updateDataTimer = NSTimer.scheduledTimerWithTimeInterval(Double(rateInSecs), target: self, selector: #selector(AppDelegate.refreshTicker(_:)), userInfo: nil, repeats: true)
        updateDataTimer.fire()
    }
    
    func refreshTicker(sender: AnyObject?){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://coinbase.com/api/v1/prices/spot_rate")!)
        request.addValue("bitcoinityBar", forHTTPHeaderField: "User-Agent")
        let connection = NSURLConnection(request: request, delegate: self)
        connection?.start()
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            bitcoinityPopover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }
    
    func closeOptionsPopover(sender: AnyObject?){
        optionsPopover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func poop(sender: AnyObject?){
        
    }
    
    func closePopover(sender: AnyObject?){
        bitcoinityPopover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func showOptionsPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            optionsPopover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.responseData = NSMutableData()
    }
    // Appends response data
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.responseData!.appendData(data)
    }
    
    // Parse data after load
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        // Parse the JSON into results
        do {
            let results = try NSJSONSerialization.JSONObjectWithData(self.responseData!, options: .AllowFragments) as! Dictionary<String, AnyObject>
            
            // Get API status
            let resultsStatus: String = (results["amount"] as! String)
            // If API call succeeded update the ticker...
            if resultsStatus != "" {
                let resultsStatusNumber: NSDecimalNumber = NSDecimalNumber(string: resultsStatus)
                let currencyStyle: NSNumberFormatter = NSNumberFormatter()
                currencyStyle.locale = NSLocale(localeIdentifier: "en_US")
                currencyStyle.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                self.ticker = currencyStyle.stringFromNumber(resultsStatusNumber)!
                setStatusItemToTickerPrice(self.ticker)
            }
            else {
                self.ticker = ""
            }
            
        } catch {
            print("error")
        }
        // Results parsed successfully from JSON
    }
    
    func toggleBitcoinityPopover(sender: AnyObject?){
        if bitcoinityPopover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func quit(sender: AnyObject?){
        NSApplication.sharedApplication().terminate(sender)
    }
    
    func toggleOptionsPopover(sender: AnyObject?){
        if optionsPopover.shown {
            closeOptionsPopover(sender)
        } else {
            showOptionsPopover(sender)
        }
    }
    
    func setStatusItemToTickerPrice(price: String){
        let attributes: [String : AnyObject] = [NSFontAttributeName: NSFont.boldSystemFontOfSize(7)]
        let attributedTitle: NSAttributedString = NSAttributedString(string: price, attributes: attributes)
        
        statusItem.button!.attributedTitle = attributedTitle
    }
    
    
}

