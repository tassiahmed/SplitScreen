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


//File System
var file_system: FileSystem = FileSystem.init()

// Layout currently being used
var layout: SnapLayout                  = SnapLayout()
var dragged_pane: Bool                  = false
var current_window_number: Int          = 0
var current_window_position: CGPoint?
var new_window_position: CGPoint?

//display the position of potential snapping  x y x1 y1
var draw_window_dims: (Int, Int, Int, Int) = (0,0, 0, 0)
var drawing: Bool                          = false
var timer_start: NSTimer                   = NSTimer()
var timer_destroy: NSTimer                 = NSTimer()
var snap_highlighter: SnapHighlighter      = SnapHighlighter()

//Used for syncing the calls from observers
var mouse_seen: Bool                = false
var mouse_up_pos: NSPoint?
var callback_seen: Bool             = false
var callback_executed: Bool         = false

//mouse position
var last_known_mouse_drag: CGPoint?


/**
	Returns the current top application by pid

	- Returns: The pid that is the top application
*/
func get_focused_pid() -> pid_t{
    let info = NSWorkspace.sharedWorkspace().frontmostApplication
	
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

func start_drawing(){
    //begin drawing again
    drawing = true
    
    //adds the dimensions info so that a window can be created
    snap_highlighter.update_window(layout.get_snap_dimensions(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y))
    snap_highlighter.draw_create()
    
    print("drawing! :)")
}

/**
    Handles the dragging of mouse
 */
func mouse_dragged_handler(event: NSEvent){
    
    last_known_mouse_drag = CGPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)
    
    if drawing {
        if layout.is_hardpoint(event.locationInWindow.x, y: event.locationInWindow.y) {
            snap_highlighter.update_window(layout.get_snap_dimensions(event.locationInWindow.x, y: event.locationInWindow.y))
        }else{
            snap_highlighter.draw_destroy()
            print(" -- Destroyed the window!")
            drawing = false
        }
    }else if layout.is_hardpoint(event.locationInWindow.x, y: event.locationInWindow.y) {
        //print(" being seen as a valid location")
        start_drawing()

    }
}

/**
	Handles the event of user releasing the mouse
 
	- Parameter event: `NSEvent` that is received when user releases the mouse
 */
func mouse_up_handler(event: NSEvent) {
    mouse_up_pos = event.locationInWindow
    mouse_seen = true
    
    if drawing {
        //snap_highlighter.kill_create()
        //snap_highlighter.preempt_destroy()
        snap_highlighter.draw_destroy()
        drawing = false
        print("++")
        //delete the window
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
func moved_callback(observer: AXObserverRef ,element: AXUIElementRef, notificationName: CFStringRef, contextData: UnsafeMutablePointer<Void>){
    
    print("SEEING CALLBACK")
    
    AXObserverRemoveNotification(observer, element, kAXMovedNotification);
    if callback_seen == false{
        callback_seen = true
    }else{
        return
    }
    callback_executed = false
    
    // Check if the mouse up handler was executed
    if mouse_seen == false {
        if drawing == false && layout.is_hardpoint(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y) {
            
            snap_highlighter = SnapHighlighter()
            start_drawing()
        }
        
        //if not drawing && in a drawable position -> start drawing
        //use mouse_dragged coupled with drawing to detect when this should be happening
        
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
    // DONT YOU DARE DELETE THIS FUNCTION
}

/**
    Sets up the observer for the moved notification
 */
func setup_observer(pid: pid_t){
    var frontMostApp: AXUIElement
    let frontMostWindow: UnsafeMutablePointer<AnyObject?> = UnsafeMutablePointer<AnyObject?>.alloc(1)
    
    frontMostApp = AXUIElementCreateApplication(pid).takeUnretainedValue()
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, frontMostWindow);
    
    // Check if the frontMostWindow object is nil or not
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
//    print("Mouse_down")
    // Reset all of the sync checks
    mouse_seen = false
    callback_seen = false
    drawing = false
    callback_executed = false
    setup_observer(get_focused_pid())
}
