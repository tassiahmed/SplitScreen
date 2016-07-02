//
//  InfoWindow.swift
//  SplitScreen
//
//  Created by Evan Thompson on 7/1/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

//class used to manager the snap highlighting
class SnapHighlighter {
    
    var timer_delay_create: NSTimer //timer used to delay creation of the highlighting window
    var timer_updater: NSTimer //timer used for window updating (.4 seconds)
    var highlight_window: NSWindow? //the actual highlighting window
    var window_dims: (Int, Int, Int, Int) //the dimensions for the hightlighting window
    
    init(){
        timer_delay_create = NSTimer()
        timer_updater = NSTimer()
        highlight_window = NSWindow()
        window_dims = (0,0,0,0)
    }
    
    //function used to create the actual window and setup the updating
    func draw_create (){
        let window_rect = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        
        //the setup for the highlighting window
        highlight_window = NSWindow(contentRect: window_rect, styleMask: 0, backing: NSBackingStoreType.Nonretained, defer: true)
        highlight_window?.opaque = true
        highlight_window?.backgroundColor = NSColor.blueColor()
        highlight_window?.setIsVisible(true)
        highlight_window?.alphaValue = 0.3
        
        //need to make the window the front most window?
        //want it to be an overlay as opposed to behind the dragged window
        //user needs to be able to see it
        
        //start updating the window
        timer_updater = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(highlight_update), userInfo: nil, repeats: true)
        
    }
    
    //callback for the delay timer
    @objc func update_on_delay() {
        //adds the dimensions info so that a window can be created
        snap_highlighter.update_window(layout.get_snap_dimensions(last_known_mouse_drag!.x, y: last_known_mouse_drag!.y))
        snap_highlighter.draw_create()
    }
    
    //sets up the timer for the delayed creation of the highlighting window
    func delay_update(delay: Double){
        timer_delay_create = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(update_on_delay), userInfo: nil, repeats: false)
    }
    
    //stops the timer for delayed creation
    func kill_delay_create(){
        timer_delay_create.invalidate()
    }
    
    //function used by a timer to update the window
    @objc func highlight_update(){
        highlight_window?.update()
    }
    
    //function used to destroy the highlighting window
    func draw_destroy (){
        timer_updater.invalidate()
        highlight_window?.opaque = false
        highlight_window?.setIsVisible(false)
    }
    
    //updates the window dimensions
    func update_window(new_dimensions: (Int, Int, Int, Int)){
        window_dims = new_dimensions
        let new_frame = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        highlight_window?.setFrame(new_frame, display: true, animate: true)
    }
}
