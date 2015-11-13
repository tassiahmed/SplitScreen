//
//  MouseDragEventHandling.swift
//  SplitScreen
//
//  Created by Evan Thompson on 10/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

import Foundation
import AppKit
import Carbon

//layout currently being used
var layout: SnapLayout = SnapLayout()
var dragged_pane: Bool = false

func get_focused_pid() -> pid_t{
    let info = NSWorkspace.sharedWorkspace().frontmostApplication
    
    if(info == NSRunningApplication()){
        return pid_t(0)
    }
    
    return (info?.processIdentifier)!
}

func mouse_up_handler(event: NSEvent) {
    if dragged_pane {
        print("was dragging...")
//		print(" ----- \(RESIZE_SCRIPT)")
		
        let loc: (CGFloat, CGFloat) = (event.locationInWindow.x, event.locationInWindow.y)
        
        let wind_num: Int = event.windowNumber
        //print(" event information: \(event.description)\n_____\n")
        //print(" Window number: \(wind_num)")
        
        if layout.is_hardpoint(loc.0, y: loc.1) {
            let resize = layout.get_snap_dimensions(loc.0, y: loc.1)
            
            //get the focused app
            let focused_pid = get_focused_pid()
            
            if(focused_pid == pid_t(0)){
                return
            }
            
            print(" focused pid: \(focused_pid.description) -> \(resize.0), \(resize.1)")
            
            move_focused_window(CFloat(resize.0), CFloat(resize.1))
            
            resize_focused_window(CFloat(resize.0), CFloat(resize.1), CFloat(resize.2), CFloat(resize.3))
            
            //print(" [|| \(event.window?.description) ||]")
            print("{ \(resize.0) : \(resize.1) : \(resize.2) : \(resize.3) }")
            
            
            
            
        }
    } else {
        print("NOT dragging...")
    }
    dragged_pane = false
}

//event handler for the mouse drag event
func mouse_dragged_handler(event: NSEvent) {
    dragged_pane = true
//    let x = event.locationInWindow.x
//    let y = event.locationInWindow.y
//    print("[ \(x) ][ \(y) ]  ====  \(layout.is_hardpoint(x, y: y))  ----- \(event.windowNumber)")
//    event.ac
	
}

func print_all_processes() {
    let apps = NSWorkspace.sharedWorkspace().runningApplications
    var count = 0
    for application in apps {
        print("\(count) : \(application)")
        count++
    }
}
