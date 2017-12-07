//
//  SnapHighlighter.swift
//  SplitScreen
//
//  Created by Evan Thompson on 7/1/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapHighlighter {
	
	/**
	fileprivate var timer_delay_create: Timer // Timer used to delay creation of the highlighting window
	fileprivate var timer_updater: Timer // Timer used for window updating (.4 seconds)
	fileprivate var highlight_window: NSWindow? // The actual highlighting window
	fileprivate var window_dims: (Int, Int, Int, Int) // The dimensions for the hightlighting window
	*/
	
	
	fileprivate var creationDelayTimer, updateTimer: Timer
	fileprivate var snapHighlight: NSWindow?
	fileprivate var windowDimensions: ((Int, Int), (Int, Int))
	
	
	/**
		Inits `SnapHighlighter` with timer vairiables and actual window
	*/
	
	/**
	init(){
	    timer_delay_create = Timer()
	    timer_updater = Timer()
	    highlight_window = NSWindow()
	    window_dims = (0,0,0,0)
	}
	*/

	init() {
		creationDelayTimer = Timer()
		updateTimer = Timer()
		snapHighlight = NSWindow()
		windowDimensions = ((0, 0), (0, 0))
	}
	
	/**
		Creates and draws the actual window also setting it up to update
	*/
	/**
	func draw_create (){
	    let window_rect = NSRect(x: window_dims.0, y: Int((NSScreen.main()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        
        // The setup for the highlighting window
	    highlight_window = NSWindow(contentRect: window_rect, styleMask: NSWindowStyleMask(rawValue: UInt(0)), backing: NSBackingStoreType.nonretained, defer: true)
	    highlight_window?.isOpaque = true
	    highlight_window?.backgroundColor = NSColor.blue
	    highlight_window?.setIsVisible(true)
	    highlight_window?.alphaValue = 0.3
	    highlight_window?.orderFrontRegardless()
        
        //need to make the window the front most window?
        //want it to be an overlay as opposed to behind the dragged window
        //user needs to be able to see it
        
        // Start updating the window
	     timer_updater = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(highlight_update), userInfo: nil, repeats: true)
        
	}
	*/
	
	func drawSnapHighlighter() {
		let windowRect = NSRect(x: windowDimensions.0.0,
		                        y: currentScreen.getDimensions().1 - (windowDimensions.0.1 + windowDimensions.1.1),
		                        width: windowDimensions.1.0,
		                        height: windowDimensions.1.1)
		snapHighlight = NSWindow(contentRect: windowRect,
		                         styleMask: NSWindow.StyleMask(rawValue: UInt(0)),
		                         backing: NSWindow.BackingStoreType.nonretained,
		                         defer: true)
		snapHighlight?.isOpaque = true
		snapHighlight?.backgroundColor = NSColor.blue
		snapHighlight?.setIsVisible(true)
		snapHighlight?.alphaValue = 0.3
		snapHighlight?.orderFrontRegardless()
		
		updateTimer = Timer.scheduledTimer(timeInterval: 0.4,
		                                   target: self,
		                                   selector: #selector(updateSnapHighlight),
		                                   userInfo: nil,
		                                   repeats: true)
	}
	
	func hideSnapHighlighter() {
		updateTimer.invalidate()
		snapHighlight?.isOpaque = false
		snapHighlight?.setIsVisible(false)
	}
	

	func updateCreationDelayTimer(_ delay: Double) {
		creationDelayTimer = Timer.scheduledTimer(timeInterval: delay,
		                                          target: self,
		                                          selector: #selector(updateAfterDelay),
		                                          userInfo: nil,
		                                          repeats: false)
	}
	
	func updateHighlighterWindow(newDimensions: ((Int, Int), (Int, Int))) {
		windowDimensions = newDimensions
		let newFrame = NSRect(x: windowDimensions.0.0,
		                      y: currentScreen.getDimensions().1 - (windowDimensions.0.1 + windowDimensions.1.1),
		                      width: windowDimensions.1.0,
		                      height: windowDimensions.1.1)
		snapHighlight?.setFrame(newFrame, display: true, animate: true)
	}
	
	func stopCreationDelayTimer() {
		creationDelayTimer.invalidate()
	}
	
	@objc func updateAfterDelay() {
		snapHighlighter.updateHighlighterWindow(
			newDimensions: layout.getResizeDimensions(x: lastKnownMouseDrag!.x,
			                                          y: lastKnownMouseDrag!.y))
		snapHighlighter.drawSnapHighlighter()
	}
	
	
	@objc func updateSnapHighlight() {
		snapHighlight?.update()
	}

	
	/**
		Callback for the delay timer
	*/
	
	/**
    @objc func update_on_delay() {
        // Adds the dimensions info so that a window can be created
        snapHighlighter.update_window(layout.get_snap_dimensions(lastKnownMouseDrag!.x, y: lastKnownMouseDrag!.y))
        snapHighlighter.draw_create()
    }
    
	/**
		Sets up the timer to delay the creation of the window
	*/
    func delay_update(_ delay: Double){
        timer_delay_create = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(update_on_delay), userInfo: nil, repeats: false)
    }
    
	/**
		Stops timer for delayed creation
	*/
    func kill_delay_create(){
        timer_delay_create.invalidate()
    }
    
	/**
		Updates the window for highlighting
	*/
    @objc func highlight_update(){
        highlight_window?.update()
    }
    
	/**
		Destroys the window
	*/
	
		/**
    func draw_destroy (){
        timer_updater.invalidate()
        highlight_window?.isOpaque = false
        highlight_window?.setIsVisible(false)
    }
		*/
    
	/**
		Updates the window dimensions
	*/
    func update_window(_ new_dimensions: (Int, Int, Int, Int)){
        window_dims = new_dimensions
        let new_frame = NSRect(x: window_dims.0, y: Int((NSScreen.main()?.frame.height)!) - (window_dims.1 + window_dims.3), width: window_dims.2, height: window_dims.3)
        highlight_window?.setFrame(new_frame, display: true, animate: true)
    }
	*/

}
