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
        // call the resize script on chrome to see if it works
        //let task1 = NSTask()
        //task1.launchPath = "/bin/pwd"
        //task1.launch()
        //exec_resize("Chrome", window_num: 1, x: 500, y: 400, x_pos: 50, y_pos: 50)
        print_all_processes()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()

        let activeApp = NSWorkspace.sharedWorkspace().frontmostApplication
        print("-------------\n\(activeApp)\n-------------")
        
        
        
        
        
		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

