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
var new_window_position: CGPoint?


var mouse_seen: Bool = false
var mouse_up_pos: NSPoint?
var callback_seen: Bool = false
var callback_executed: Bool = false

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
func comparePosition() -> Bool {
	return (current_window_position!.x == new_window_position!.x && current_window_position!.y == new_window_position!.y)
}

/**
    Moves and Resizes the current window depending on the location of where the mouse up location was
*/
func move_and_resize(){
    let loc: (CGFloat, CGFloat) = (mouse_up_pos!.x, mouse_up_pos!.y)
    
    if layout.is_hardpoint(loc.0, y: loc.1) {
        let resize = layout.get_snap_dimensions(loc.0, y: loc.1)
        
        // Gets the focused app
        let focused_pid = get_focused_pid()
        
        // Stops if there was no focused app to resize
        if(focused_pid == pid_t(0)){
            return
        }
        
        
        // Moves and resizes the focused window
        move_focused_window(CFloat(resize.0), CFloat(resize.1), focused_pid)
        resize_focused_window(CFloat(resize.2), CFloat(resize.3), focused_pid)
    }
    
}

/**
	Handles the event of user releasing the mouse
 
	- Parameter event: `NSEvent` that is received when user releases the mouse
 */
func mouse_up_handler(event: NSEvent) {
    print("mouse_up")
    mouse_up_pos = event.locationInWindow
    mouse_seen = true;
    
    //check if the callback was executed too early
    if callback_seen && callback_executed == false {
        callback_seen = false
        move_and_resize()
    }else{
        callback_executed = false
        callback_seen = false
    }
    
}

/**
    Call back function for when a specific window moves
 */
func moved_callback(observer: AXObserverRef ,element: AXUIElementRef, notificationName: CFStringRef, contextData: UnsafeMutablePointer<Void>){
    
    AXObserverRemoveNotification(observer, element, kAXMovedNotification);
    if callback_seen == false{
        callback_seen = true
        print(" * running callback")
    }else{
        print(" ! exiting callback")
        return
    }
    callback_executed = false
    
    //check if the mouse up handler was executed
    if mouse_seen == false {
        return
    }

    callback_executed = true
    move_and_resize();
}

/**
    DUMMY FUNCTION REQUIRED FOR LEGACY C CODE
 
    DO NOT REFACTOR
 
    IT ACTUALLY IS IMPORTANT
 */
func data(){
    //DONT YOU DARE DELETE THIS FUNCTION
}

/**
    Sets up the observer for the moved notification
 */
func setup_observer(pid: pid_t){
    var frontMostApp: AXUIElement
    let frontMostWindow: UnsafeMutablePointer<AnyObject?> = UnsafeMutablePointer<AnyObject?>.alloc(1)
    
    frontMostApp = AXUIElementCreateApplication(pid).takeUnretainedValue()
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, frontMostWindow);
    
    //Check if the frontMostWindow object is nil or not
    if let placeHolder = frontMostWindow.memory {
        let frontMostWindow_true: AXUIElementRef = placeHolder as! AXUIElementRef
       
        let observer: UnsafeMutablePointer<AXObserverRef?> = UnsafeMutablePointer<AXObserverRef?>.alloc(1)
        AXObserverCreate(pid, moved_callback, observer)
        let observer_true: AXObserverRef = observer.memory!
        let data_ptr: UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>.alloc(1)
        data_ptr.memory = data()
        AXObserverAddNotification(observer_true, frontMostWindow_true, kAXMovedNotification, data_ptr);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer_true).takeUnretainedValue(), kCFRunLoopDefaultMode);
    }
}

/**
    Handles the mouse down event
 */
func mouse_down_handler(event: NSEvent){
    print("Mouse_down")
    //reset all of the sync checks
    mouse_seen = false
    callback_seen = false
    callback_executed = false
    setup_observer(get_focused_pid())
}
