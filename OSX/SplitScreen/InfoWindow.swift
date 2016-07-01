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
    var highlight_window: NSWindow?
    var window_dims: (Int, Int, Int, Int)
    
    
    init(){
        timer_create = NSTimer()
        timer_destroy = NSTimer()
        highlight_window = NSWindow()
        window_dims = (0,0,0,0)
    }
    
    //functions for the timers
    @objc func draw_create (){
        let window_rect = NSRect(x: window_dims.0, y: window_dims.1, width: window_dims.3 - window_dims.1, height: window_dims.2 - window_dims.0)
        print("!! \(window_rect)")
        //busted!
        highlight_window = NSWindow(contentRect: window_rect, styleMask: 1, backing: NSBackingStoreType.Nonretained, defer: true)
        print("@@ \(highlight_window)")
        highlight_window?.opaque = true
        highlight_window?.backgroundColor = NSColor.blueColor()
        print("built the window!")
    }
    
    @objc func draw_remove (){
        highlight_window?.opaque = false
        print("removed the window!")
    }
    
    func start_timers(dimensions: (Int, Int, Int, Int)){
        window_dims = dimensions
        timer_destroy = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: #selector(draw_remove), userInfo: nil, repeats: false)
        timer_create = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(draw_create), userInfo: nil, repeats: false)
    }
    
    func kill_destory(){
        timer_destroy.invalidate()
    }
    
    func kill_create(){
        timer_create.invalidate()
    }
    
    func preempt_destory(){
        timer_destroy.fire()
        timer_destroy.invalidate()
    }
    
}
