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
var dragged_pane: Bool = false

func mouse_up_handler(event: NSEvent) {
    if dragged_pane {
        print("was dragging...")
//		print(" ----- \(RESIZE_SCRIPT)")
		
        let loc: (CGFloat, CGFloat) = (event.locationInWindow.x, event.locationInWindow.y)
        
        if layout.is_hardpoint(loc.0, y: loc.1) {
            let resize = layout.get_snap_dimensions(loc.0, y: loc.1)
            
            print("{ \(resize.0) : \(resize.1) : \(resize.2) : \(resize.3) }")
            
            let RESIZE_SCRIPT: String = "tell application \"System Events\"\n set theprocess to the first process whose frontmost is true\n set thewindow to the value of attribute \"AXFocusedWindow\" of theprocess\n set size of thewindow to {\(resize.2), \(resize.3)}\n set the position of thewindow to {\(resize.0), \(resize.1)}\n end tell"
            
            var error: NSDictionary?
            if let scriptObj = NSAppleScript(source: RESIZE_SCRIPT) {
                if let output: NSAppleEventDescriptor = scriptObj.executeAndReturnError(&error) {
                    print(output.stringValue)
                } else if (error != nil) {
                    print("ERROR: \(error)")
                }
            }
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
