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

private var current_window_position: CGPoint?
private var new_window_position: CGPoint?
private var drawing: Bool = false
private var mouse_seen: Bool = false
private var mouse_up_pos: NSPoint?
private var callback_seen: Bool = false
private var callback_executed: Bool = false

/**
	Returns the current top application by pid

	- Returns: The pid that is the top application
*/
func get_focused_pid() -> pid_t{
    let info = NSWorkspace.shared().frontmostApplication
	
	// If the focused app is `SplitScreen` return a `pid` of 0
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
        print(" ++ \(resize)")
        if resize.0 == -1 || resize.1 == -1 || resize.2 == -1 || resize.3 == -1 {
            return
        }
        
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
    Starts the drawing process for the highlighting window
 */
func start_drawing(){
    //begin drawing again
    drawing = true
    
    //adds the dimensions info so that a window can be created
    snap_highlighter.update_window(layout.get_snap_dimensions(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y))
    snap_highlighter.draw_create()
}

/**
    Handles the dragging of mouse
 
    - Parameter event: the input event for mouse dragging
 */
func mouse_dragged_handler(_ event: NSEvent){
    
    //holds a reference to the last position of a drag
    last_known_mouse_drag = CGPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)
    if callback_seen {
        if drawing {
            //if still in a position that requires highlighting
            if layout.is_hardpoint(event.locationInWindow.x, y: event.locationInWindow.y) {
                snap_highlighter.update_window(layout.get_snap_dimensions(event.locationInWindow.x, y: event.locationInWindow.y))
                print(layout.get_snap_dimensions(event.locationInWindow.x, y: event.locationInWindow.y))
            }else{
                snap_highlighter.draw_destroy()
                drawing = false
            }
        }else if layout.is_hardpoint(event.locationInWindow.x, y: event.locationInWindow.y) {
            drawing = true
            //prevents annoying immediate display during quick motions
            //also prevents lag on highligh window creation
            snap_highlighter.delay_update(0.2)
        }
    }
}

/**
	Handles the event of user releasing the mouse
 
	- Parameter event: `NSEvent` that is received when user releases the mouse
 */
func mouse_up_handler(_ event: NSEvent) {
    print("mouse up")
    
    mouse_up_pos = event.locationInWindow
    mouse_seen = true
    
    if drawing {
        //end the drawing
        snap_highlighter.kill_delay_create()
        snap_highlighter.draw_destroy()
        drawing = false
    }
    
    // Check if the callback was executed too early
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
func moved_callback(_ observer: AXObserver, element: AXUIElement, notificationName: CFString, contextData: UnsafeMutableRawPointer?) -> Void {
    
    AXObserverRemoveNotification(observer, element, kAXMovedNotification as CFString);
    if callback_seen == false{
        callback_seen = true
    }else{
        return
    }
    callback_executed = false
    
    // Check if the mouse up handler was executed
    if mouse_seen == false {
        //handle highlighting
        if drawing == false && layout.is_hardpoint(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y) {
            snap_highlighter = SnapHighlighter()
            start_drawing()
        }
        
        return
    }

    callback_executed = true
    move_and_resize();
}

/**
    Sets up the observer for the moved notification
 */
func setup_observer(_ pid: pid_t){
    var frontMostApp: AXUIElement
    let frontMostWindow: UnsafeMutablePointer<AnyObject?> = UnsafeMutablePointer<AnyObject?>.allocate(capacity: 1)
    
    frontMostApp = AXUIElementCreateApplication(pid)
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute as CFString, frontMostWindow);
    
    // Check if the frontMostWindow object is nil or not
    if let placeHolder = frontMostWindow.pointee {
        let frontMostWindow_true: AXUIElement = placeHolder as! AXUIElement
       
        let observer: UnsafeMutablePointer<AXObserver?> = UnsafeMutablePointer<AXObserver?>.allocate(capacity: 1)
        AXObserverCreate(pid, moved_callback as AXObserverCallback, observer)
        let observer_true: AXObserver = observer.pointee!
        let data_ptr: UnsafeMutablePointer<UInt16> = UnsafeMutablePointer<UInt16>.allocate(capacity: 1)
		
        AXObserverAddNotification(observer_true, frontMostWindow_true, kAXMovedNotification as CFString, data_ptr);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer_true), CFRunLoopMode.defaultMode);
    }
}

/**
    Handles the mouse down event
 */
func mouse_down_handler(_ event: NSEvent){
    // Reset all of the sync checks
    mouse_seen = false
    callback_seen = false
    drawing = false
    callback_executed = false
    setup_observer(get_focused_pid())
}
