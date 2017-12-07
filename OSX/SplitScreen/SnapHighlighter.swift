//  SnapHighlighter.swift
//  SplitScreen
//
//  Created by Evan Thompson on 7/1/16.
//  Copyright © 2016 SplitScreen. All rights reserved.

import Foundation
import AppKit

class SnapHighlighter {

  fileprivate var creationDelayTimer: Timer // Timer used to delay creation of the highlighting window
  fileprivate var updateTimer: Timer // Timer used for window updating (.4 seconds)
  fileprivate var highlightWindow: NSWindow? // The actual highlighting window
  fileprivate var windowDimensions: (Int, Int, Int, Int) // The dimensions for the hightlighting window

	/**
		Inits `SnapHighlighter` with timer vairiables and actual window
	*/
  init() {
    creationDelayTimer = Timer()
    updateTimer = Timer()
    highlightWindow = NSWindow()
    windowDimensions = (0,0,0,0)
  }

	/**
		Creates and draws the actual window also setting it up to update
	*/
  func draw_create () {
    let window_rect = NSRect(x: windowDimensions.0, y: Int((NSScreen.main?.frame.height)!) - (windowDimensions.1 + windowDimensions.3), width: windowDimensions.2, height: windowDimensions.3)

    // The setup for the highlighting window
    highlightWindow = NSWindow(contentRect: window_rect, styleMask: NSWindow.StyleMask(rawValue: UInt(0)), backing: NSWindow.BackingStoreType.nonretained, defer: true)
    highlightWindow?.isOpaque = true
    highlightWindow?.backgroundColor = NSColor.blue
    highlightWindow?.setIsVisible(true)
    highlightWindow?.alphaValue = 0.3
    highlightWindow?.orderFrontRegardless()

    // need to make the window the front most window?
    // want it to be an overlay as opposed to behind the dragged window
    // user needs to be able to see it

    // Start updating the window
    updateTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(highlight_update), userInfo: nil, repeats: true)
  }

	/**
		Callback for the delay timer
	*/
  @objc func update_on_delay() {
    // Adds the dimensions info so that a window can be created
    snapHighlighter.update_window(layout.get_snap_dimensions(lastKnownMouseDrag!.x, y: lastKnownMouseDrag!.y))
    snapHighlighter.draw_create()
  }

	/**
		Sets up the timer to delay the creation of the window
	*/
  func delay_update(_ delay: Double) {
    creationDelayTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(update_on_delay), userInfo: nil, repeats: false)
  }

	/**
		Stops timer for delayed creation
	*/
  func kill_delay_create(){
    creationDelayTimer.invalidate()
  }

	/**
		Updates the window for highlighting
	*/
  @objc func highlight_update() {
    highlightWindow?.update()
  }

	/**
		Destroys the window
	*/
  func draw_destroy () {
    updateTimer.invalidate()
    highlightWindow?.isOpaque = false
    highlightWindow?.setIsVisible(false)
  }

	/**
		Updates the window dimensions
	*/
  func update_window(_ new_dimensions: (Int, Int, Int, Int)) {
    windowDimensions = new_dimensions
    let new_frame = NSRect(x: windowDimensions.0, y: Int((NSScreen.main?.frame.height)!) - (windowDimensions.1 + windowDimensions.3), width: windowDimensions.2, height: windowDimensions.3)
    highlightWindow?.setFrame(new_frame, display: true, animate: true)
  }
}
