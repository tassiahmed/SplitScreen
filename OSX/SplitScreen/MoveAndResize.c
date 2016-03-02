//
//  MoveAndResize.c
//  SplitScreen
//
//  Created by Evan Thompson on 11/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

#include "MoveAndResize.h"

/**
	Get the front most app
 
    - Parameter pid: front most pid (use swift to get this)
 
	- Returns: `AXUIElementRef` of front most app
 */
static AXUIElementRef getFrontMostApp(pid_t pid){
        return AXUIElementCreateApplication(pid);
}

/**
	Get position of the user focused window
 
	- Returns: `CGPoint` that corresponds to the focused window's position
 */
CGPoint get_focused_window_position(pid_t pid) {
	CGPoint ret;
	AXValueRef temp;
	AXUIElementRef frontMostApp;
	AXUIElementRef frontMostWindow;
	
	// Get the front most app
	frontMostApp = getFrontMostApp(pid);
	AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);
    
	// Copy the window position attribute from frontMostWindow
	AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
	AXValueGetValue(temp, kAXValueCGPointType, &ret);
	CFRelease(temp);
    CFRelease(frontMostWindow);
    CFRelease(frontMostApp);
	return ret;
}

/**
	Moves the focused window to specified `x`, `y` coordinates
 
	- Parameter x: new window screen x coordinate
 
	- Parameter y: new window screen y coordinate
 
    - Parameter pid: front most pid (use swift to get this)
 */
void move_focused_window(float x, float y, pid_t pid) {
    AXValueRef temp;
    CGSize windowSize;
    CGPoint windowPosition;
    CFStringRef windowTitle;
    AXUIElementRef frontMostApp;
    AXUIElementRef frontMostWindow;
	
	// Get the front most app
    frontMostApp = getFrontMostApp(pid);

	// Copy window attributes from frontMostApp
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);

    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&windowTitle);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);

//    printf("\n");
//    CFShow(windowTitle);
//    printf("Moved window to (%f, %f)\n", windowPosition.x, windowPosition.y);
	
	// Change the window position to prevent error upon trying to move to same position
    windowPosition.x += 1;
    windowPosition.y += 1;
    temp = AXValueCreate(kAXValueCGPointType, &windowPosition);
    AXUIElementSetAttributeValue(frontMostWindow, kAXPositionAttribute, temp);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);
	
	// Change the window position to the desired position that is provided in params
    windowPosition.x = x;
    windowPosition.y = y;
    temp = AXValueCreate(kAXValueCGPointType, &windowPosition);
    AXUIElementSetAttributeValue(frontMostWindow, kAXPositionAttribute, temp);
    CFRelease(temp);
    CFRelease(frontMostWindow);
    CFRelease(frontMostApp);
    
}

/**
    Prints the size of the window of the given pid
    
    - Parameter pid: the pid of the desired window
 */
void print_window_size(pid_t pid){
    AXValueRef temp;
    CGSize windowSize;
    CGPoint windowPosition;
    CFStringRef windowTitle;
    AXUIElementRef frontMostApp;
    AXUIElementRef frontMostWindow;
    
    // Get the frontMostApp
    frontMostApp = getFrontMostApp(pid);
    
    // Copy window attributes
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&windowTitle);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);
    
    printf(" SIZE OF WINDOW IS: %f, %f \n", windowSize.width, windowSize.height);
    
}


/**
	Resizes the focused window to specified sizes `x`, `y`
 
	- Parameter x: new window width
 
	- Parameter y: new window height
 
    - Parameter pid: front most pid (use swift to get this)
 */
void resize_focused_window(float x, float y, pid_t pid){
    AXValueRef temp;
    CGSize windowSize;
    CGPoint windowPosition;
    CFStringRef windowTitle;
    AXUIElementRef frontMostApp;
    AXUIElementRef frontMostWindow;
	
	// Get the frontMostApp
    frontMostApp = getFrontMostApp(pid);
	
	// Copy window attributes
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&windowTitle);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);
    
    //printf("\n");
//    CFShow(windowTitle);
    //printf("RESIZE: Window is at (%f, %f) and has dimensions of (%f, %f) resized to (%f, %f) according to (%f, %f, %f, %f)\n", windowPosition.x, windowPosition.y, windowSize.width, windowSize.height, x1-x, y1 - y, x, y, x1, y1);

	// Change the window size
    windowSize.width = x;
    windowSize.height = y;

//    printf(" \n-- Resized window to dimensions: (%f, %f))\n\n", windowSize.width, windowSize.height);
	
    temp = AXValueCreate(kAXValueCGSizeType, &windowSize);
    AXUIElementSetAttributeValue(frontMostWindow, kAXSizeAttribute, temp);
    CFRelease(temp);
    CFRelease(frontMostWindow);
    CFRelease(frontMostApp);

}



