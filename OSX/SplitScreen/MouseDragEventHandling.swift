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


/**
	Returns the current top application by pid

	- Returns: The pid that is the top application
*/
func get_focused_pid() -> pid_t{
    let info = NSWorkspace.sharedWorkspace().frontmostApplication
    
    if(info == NSRunningApplication()){
        return pid_t(0)
    }
    
    return (info?.processIdentifier)!
}


/**
	Compares the coordinates of `current_window_position` with the coordinates of `new_position`

	- Parameter new_position: The `CGPoint` whose coordinates to compare w/ those of `current_window_position`
	
	- Returns: `true` or `false` depending on whether `current_window_position` and `new_position` have the same coordinates
*/
func comparePosition(new_position: CGPoint) -> Bool {
	return (current_window_position!.x == new_position.x && current_window_position!.y == new_position.y)
}


/**
	Confirms that the top window application has been dragged to a new position

	- Parameter event: `NSEvent` that is passed along from when the user has released the mouse

	- Returns: `false` if the `current_window_number` is not the same as `event.windowNumber` or `comparePosition()` is `true`
*/
func confirmWindowDragged(event: NSEvent) -> Bool {
	if current_window_number != event.windowNumber {
		return false
	}
	
//	print("Current Position: X:\(current_window_position!.x) Y:\(current_window_position!.y)")
//	print("New Position: X:\(get_focused_window_position().x) Y:\(get_focused_window_position().y)\n")
	
	if comparePosition(get_focused_window_position()) {
//		print ("Position is unchanged")
		return false
	}
	return true
}


/**
	Handles the event of user releasing the mouse

	- Parameter event: `NSEvent` that is received when user releases the mouse
*/
func mouse_up_handler(event: NSEvent) {
	// Check for window drag
    if dragged_pane && confirmWindowDragged(event) {
		// Get the
        let loc: (CGFloat, CGFloat) = (event.locationInWindow.x, event.locationInWindow.y)
		
        if layout.is_hardpoint(loc.0, y: loc.1) {
            let resize = layout.get_snap_dimensions(loc.0, y: loc.1)
            
            // Gets the focused app
            let focused_pid = get_focused_pid()
			
			// Stops if there was no focused app to resize
            if(focused_pid == pid_t(0)){
                return
            }
			
			// Moves and resizes the focused window
            move_focused_window(CFloat(resize.0), CFloat(resize.1))
            resize_focused_window(CFloat(resize.2), CFloat(resize.3))
        }
    }
    dragged_pane = false
}

/**
	Handles the event of user clicking down on the mouse

	- Parameter event: `NSEvent` that is received when user clicks the mouse
*/
func mouse_down_handler(event: NSEvent) {
	current_window_number = event.windowNumber
	current_window_position = get_focused_window_position()
}

/**
	Handles the event of user drags the mouse

	- Parameter event: `NSEvent` that is received when user drags the mouse
*/
func mouse_dragged_handler(event: NSEvent) {
	// Handle the case of dragging to corner
	if !dragged_pane {
		dragged_pane = true
	}
}

/**
	Prints all current running process on computer
*/
func print_all_processes() {
    let apps = NSWorkspace.sharedWorkspace().runningApplications
    var count = 0
    for application in apps {
		print("\(count) : \(application)")
		count++
    }
}
