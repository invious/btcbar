//
//  OptViewController.swift
//  traymenu_tutorial
//
//  Created by Aymon Fournier on 6/18/16.
//  Copyright © 2016 Aymon Fournier. All rights reserved.
//

import Cocoa

class OptViewController: NSViewController {

    @IBOutlet var refreshSlider : NSSlider!
    @IBOutlet var refreshTextField : NSTextField!
    internal var refreshRate : Int32 = 5
    let appD = NSApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        refreshRate = Int32(refreshSlider.doubleValue)
        refreshSlider.intValue = refreshRate
        refreshTextField.intValue = refreshRate
    }
    
}

extension OptViewController {
    @IBAction func changeRefreshRateSliderValue(sender: NSSlider) {
        refreshRate = Int32(refreshSlider.doubleValue)
        refreshTextField.intValue = refreshRate
    }
    
    @IBAction func changeRefreshRateTextValue(sender: NSTextField) {
        refreshRate = Int32(refreshTextField.doubleValue)
        refreshSlider.intValue = refreshRate
        appD.setRefreshRate(refreshRate)
    }
}
