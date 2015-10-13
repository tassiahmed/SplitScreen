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
    
    //needs to be fixed
    func exec_resize(proc_name: String, window_num: Int, x: Int, y: Int, x_pos: Int, y_pos: Int){
        
        
        let RESIZE_SCRIPT = "property defaultWindowName : \"Chrome\" on set_window_size(window_name, window_num, x, y, x_pos, y_pos) #log window_name & \" | \" & window_num & \" | \" & x & \" | \" & y & \" | \" & x_pos & \" | \" & y_pos ignoring application responses tell application \"System Events\" tell process window_name activate set size of window window_num to {x, y} set position of window window_num to {x_pos, y_pos} end tell end tell end ignoring end set_window_size on run set_window_size(\(proc_name), \(window_num), \(x), \(y), \(x_pos), \(y_pos)) end run"
        
        var error: NSDictionary?
        if let scriptObj = NSAppleScript(source: RESIZE_SCRIPT){
            if let output: NSAppleEventDescriptor = scriptObj.executeAndReturnError(&error){
                print(output.stringValue)
            }else if(error != nil){
                print("ERROR: \(error)")
            }
        }
        
    }
    
    func print_all_processes(){
        let apps = NSWorkspace.sharedWorkspace().runningApplications
        var count = 0
        for application in apps{
            print("\(count) : \(application)")
            count++
        }
    }
    
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

        let activeApp = NSWorkspace.sharedWorkspace().activeApplication()
        print("-------------\n\(activeApp)\n-------------")
        
        
        
        
		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

