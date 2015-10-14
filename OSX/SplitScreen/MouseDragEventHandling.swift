//
//  MouseDragEventHandling.swift
//  SplitScreen
//
//  Created by Evan Thompson on 10/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

//layout currently being used
var layout: SnapLayout = SnapLayout()

//event handler for the mouse drag event
func mouse_dragged_handler(event: NSEvent){
    let x = event.locationInWindow.x
    let y = event.locationInWindow.y
    print("[ \(x) ][ \(y) ]  ====  \(layout.is_hardpoint(x, y: y))")
    
}
//completely broken as of right now --> possible swift way of doing it?
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
