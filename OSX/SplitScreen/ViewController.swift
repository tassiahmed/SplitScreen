//
//  ViewController.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 9/8/15.
//  Copyright (c) 2015 SplitScreen. All rights reserved.
//

import Cocoa
import Foundation
import AppKit
import AppKitScripting

class ViewController: NSViewController {
    
    
    @IBAction func resizeChrome(sender: NSButton) {
        print_all_processes()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()

//        let activeApp = NSWorkspace.sharedWorkspace().frontmostApplication
//        print("-------------\n\(activeApp)\n-------------")
//        
//        let (height, width) = (NSScreen.mainScreen()?.frame.height, NSScreen.mainScreen()?.frame.width)
//        print("++++++++++++++ \(width) x \(height)")
		
        
		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

