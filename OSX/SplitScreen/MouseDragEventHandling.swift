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

// Layout currently being used
var layout: SnapLayout = SnapLayout()
var dragged_pane: Bool = false
var current_window_number: Int = 0
var current_window_position: CGPoint?

// Get the current top application by pid
func get_focused_pid() -> pid_t{
    let info = NSWorkspace.sharedWorkspace().frontmostApplication
    
    if(info == NSRunningApplication()){
        return pid_t(0)
    }
    
    return (info?.processIdentifier)!
}

// Compare the coordinates between new_postion and current_window_position
func comparePosition(new_position: CGPoint) -> Bool {
	return (current_window_position!.x == new_position.x && current_window_position!.y == new_position.y)
}

// Makes sure that a window has been dragged
func confirmWindowDragged(event: NSEvent) -> Bool {
	if current_window_number != event.windowNumber {
		return false
	}
	if comparePosition(get_focused_window_position()) {
		return false
	}
	return true
}

// Event handler for the mouse release event
func mouse_up_handler(event: NSEvent) {
	// Check for window drag
    if dragged_pane && confirmWindowDragged(event) {
        let loc: (CGFloat, CGFloat) = (event.locationInWindow.x, event.locationInWindow.y)
		
        if layout.is_hardpoint(loc.0, y: loc.1) {
            let resize = layout.get_snap_dimensions(loc.0, y: loc.1)
            
            // Get the focused app
            let focused_pid = get_focused_pid()
            
            if(focused_pid == pid_t(0)){
                return
            }
			
			// Move and resize focused windows
            move_focused_window(CFloat(resize.0), CFloat(resize.1))
            resize_focused_window(CFloat(resize.0), CFloat(resize.1), CFloat(resize.2), CFloat(resize.3))
			
//            print(" focused pid: \(focused_pid.description) -> \(resize.0), \(resize.1)")
//            print(" [|| \(event.window?.description) ||]")
//            print("{ \(resize.0) : \(resize.1) : \(resize.2) : \(resize.3) }")
			
            
        }
    }
    dragged_pane = false
}

// Event handler for the mouse drag event
func mouse_dragged_handler(event: NSEvent) {
	// Handle the case of dragging to corner
	if !dragged_pane {
		dragged_pane = true
		current_window_number = event.windowNumber
		current_window_position = get_focused_window_position()
	}
}

func print_all_processes() {
    let apps = NSWorkspace.sharedWorkspace().runningApplications
    var count = 0
    for application in apps {
        print("\(count) : \(application)")
        count++
    }
}
