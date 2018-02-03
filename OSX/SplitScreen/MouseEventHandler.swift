//
//  MouseEventHandler.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 12/25/17.
//  Copyright © 2017 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

private var currentWindowPosition: CGPoint = CGPoint()
private var newWindowPosition: CGPoint = CGPoint()
private var mouseUpPosition: NSPoint = NSPoint()
private var isDrawing: Bool = false
private var mouseSeen: Bool = false
private var callbackSeen: Bool = false
private var callbackExecuted: Bool = false

func getFocusedPid() -> pid_t {
	let focusedApp = NSWorkspace.shared.frontmostApplication

	if focusedApp == NSRunningApplication() {
		return pid_t(0)
	}

	return (focusedApp?.processIdentifier)!
}

func compareWindowPosition() -> Bool {
	return currentWindowPosition.x == newWindowPosition.x &&
		currentWindowPosition.y == newWindowPosition.y
}

func snapWindow() {
	if layout.isHardPoint(x: mouseUpPosition.x, y: mouseUpPosition.y) {
		let snapWindow = layout.getSnapWindow(x: mouseUpPosition.x, y: mouseUpPosition.y)

		if snapWindow.0.0 == -1 || snapWindow.0.1 == -1 || snapWindow.1.0 == -1 || snapWindow.1.1 == -1 {
			return
		}

		let focusedPid = getFocusedPid()

		if focusedPid == pid_t(0) {
			return
		}

		move_focused_window(CFloat(snapWindow.0.0), CFloat(snapWindow.0.1), focusedPid)
		resize_focused_window(CFloat(snapWindow.1.0), CFloat(snapWindow.1.1), focusedPid)
	}
}

func drawWindowHighlight() {
	isDrawing = true
	snapHighlighter.update(layout.getSnapWindow(x: lastKnownMouseDrag!.x,
																							y: lastKnownMouseDrag!.y))
	snapHighlighter.draw()
}

func mouseDraggedHandler(_ event: NSEvent) {
	lastKnownMouseDrag = CGPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)
	if callbackSeen {
		if isDrawing {
			if layout.isHardPoint(x: event.locationInWindow.x, y: event.locationInWindow.y) {
				snapHighlighter.update(layout.getSnapWindow(x: event.locationInWindow.x,
																										y: event.locationInWindow.y))
				print(layout.getSnapWindow(x: event.locationInWindow.x, y: event.locationInWindow.y))
			} else {
				snapHighlighter.endDrawing()
				isDrawing = false
			}
		}
	} else if layout.isHardPoint(x: event.locationInWindow.x, y: event.locationInWindow.y) {
		isDrawing = true
		snapHighlighter.delayDraw(0.2)
	}
}

func mouseUpHandler(_ event: NSEvent) {
	mouseUpPosition = event.locationInWindow
	mouseSeen = true

	if isDrawing {
		snapHighlighter.endDrawDelay()
		snapHighlighter.endDrawing()
		isDrawing = false
	}
	if callbackSeen && !callbackExecuted {
		callbackSeen = false
		snapWindow()
	} else {
		callbackExecuted = false
		callbackSeen = false
	}
}

func mouseDownHandler(_ event: NSEvent) {
	mouseSeen = false
	callbackSeen = false
	isDrawing = false
	callbackExecuted = false
}

func movedCallback(observer: AXObserver, element: AXUIElement,
	notification: CFString, context: UnsafeMutableRawPointer?) {
	AXObserverRemoveNotification(observer, element, kAXMovedNotification as CFString)

	if !callbackSeen {
		callbackSeen = true
	} else {
		return
	}

	callbackExecuted = false

	if !mouseSeen {
		if !isDrawing && layout.isHardPoint(x: lastKnownMouseDrag!.x, y: lastKnownMouseDrag!.y) {
			drawWindowHighlight()
		}

		return
	}

	callbackExecuted = true
	snapWindow()
}

func setupDragObserver(_ pid: pid_t) {
	let frontMostWindow: UnsafeMutablePointer<AnyObject?> = UnsafeMutablePointer<AnyObject?>.allocate(capacity: 1)
	let frontMostApp: AXUIElement = AXUIElementCreateApplication(pid)

	AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute as CFString, frontMostWindow)

	if frontMostWindow.pointee != nil {
		let frontMostWindowRef: AXUIElement = frontMostWindow.pointee as! AXUIElement
		let observer: UnsafeMutablePointer<AXObserver?> = UnsafeMutablePointer<AXObserver?>.allocate(capacity: 1)
		AXObserverCreate(pid, movedCallback as AXObserverCallback, observer)
		let observerRef: AXObserver = observer.pointee!
		let dataPointer: UnsafeMutablePointer<UInt16> = UnsafeMutablePointer<UInt16>.allocate(capacity: 1)

		AXObserverAddNotification(observerRef, frontMostWindowRef, kAXMovedNotification as CFString, dataPointer)
		CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observerRef), CFRunLoopMode.defaultMode);
	}
}
