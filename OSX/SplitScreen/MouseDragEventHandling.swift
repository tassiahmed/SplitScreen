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
            
            //print(" [|| \(event.window?.description) ||]")
            print("{ \(resize.0) : \(resize.1) : \(resize.2) : \(resize.3) }")
            
            //var window_rect = event.window?.accessibilityFrame()
            
            //window_rect?.size = NSSize.init(width: resize.2, height: resize.3)
            //window_rect?.origin = NSPoint.init(x: resize.0, y: resize.1)
            
            
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
