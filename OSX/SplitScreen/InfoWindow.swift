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
    
    var timer_create: NSTimer
    var timer_destroy: NSTimer
    var timer_updater: NSTimer
    var highlight_window: NSWindow?
    var window_dims: (Int, Int, Int, Int)
    
    
    init(){
        timer_create = NSTimer()
        timer_destroy = NSTimer()
        timer_updater = NSTimer()
        highlight_window = NSWindow()
        window_dims = (0,0,0,0)
    }
    
    //functions for the timers
    @objc func draw_create (){
        print("(\(window_dims.0),\(window_dims.1),\(window_dims.2),\(window_dims.3))")
        let window_rect = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        print("!! \(window_rect)")
        //busted!
        highlight_window = NSWindow(contentRect: window_rect, styleMask: 0, backing: NSBackingStoreType.Nonretained, defer: true)
        print("@@ \(highlight_window)")
        highlight_window?.opaque = true
        highlight_window?.backgroundColor = NSColor.blueColor()
        highlight_window?.display()
        highlight_window?.setIsVisible(true)
        print("built the window!")
        
        timer_updater = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(highlight_update), userInfo: nil, repeats: true)
        
    }
    
    @objc func highlight_update(){
        highlight_window?.update()
    }
    
    @objc func draw_destroy (){
        timer_updater.invalidate()
        highlight_window?.opaque = false
        highlight_window?.setIsVisible(false)
        print("removed the window!")
    }
    
    func start_timers(dimensions: (Int, Int, Int, Int)){
        window_dims = dimensions
        
        timer_destroy = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(draw_destroy), userInfo: nil, repeats: false)
        timer_create = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(draw_create), userInfo: nil, repeats: false)
    }
    
    func kill_destory(){
        timer_destroy.invalidate()
    }
    
    func kill_create(){
        timer_create.invalidate()
    }
    
    func update_window(new_dimensions: (Int, Int, Int, Int)){
        window_dims = new_dimensions
        let new_frame = NSRect(x: window_dims.0, y: Int((NSScreen.mainScreen()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        highlight_window?.setFrame(new_frame, display: true, animate: true)
    }
    
    func preempt_destroy(){
        timer_destroy.fire()
        timer_destroy.invalidate()
    }
    
}
