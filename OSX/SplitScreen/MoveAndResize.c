//
//  MoveAndResize.c
//  SplitScreen
//
//  Created by Evan Thompson on 11/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

#include "MoveAndResize.h"


static AXUIElementRef getFrontMostApp(){
        pid_t pid;
        ProcessSerialNumber psn;
        GetFrontProcess(&psn);
        GetProcessPID(&psn, &pid);
        return AXUIElementCreateApplication(pid);
}

CGPoint get_focused_window_position() {
	CGPoint ret;
	AXValueRef temp;
	AXUIElementRef frontMostApp;
	AXUIElementRef frontMostWindow;
	
	frontMostApp = getFrontMostApp();
	AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);
	
	AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
	AXValueGetValue(temp, kAXValueCGPointType, &ret);
	CFRelease(temp);
	
	return ret;
}

void move_focused_window(float x, float y) {
    AXValueRef temp;
    CGSize windowSize;
    CGPoint windowPosition;
    CFStringRef windowTitle;
    AXUIElementRef frontMostApp;
    AXUIElementRef frontMostWindow;
    
    frontMostApp = getFrontMostApp();

    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);

    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&windowTitle);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);

    printf("\n");
    CFShow(windowTitle);
    printf("Moved window to (%f, %f)\n", windowPosition.x, windowPosition.y);
    
    windowPosition.x += 1;
    windowPosition.y += 1;
    temp = AXValueCreate(kAXValueCGPointType, &windowPosition);
    AXUIElementSetAttributeValue(frontMostWindow, kAXPositionAttribute, temp);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);
    
    windowPosition.x = x;
    windowPosition.y = y;
    temp = AXValueCreate(kAXValueCGPointType, &windowPosition);
    AXUIElementSetAttributeValue(frontMostWindow, kAXPositionAttribute, temp);
    CFRelease(temp);
    CFRelease(frontMostWindow);
    CFRelease(frontMostApp);
    
}


void resize_focused_window(float x, float y, float x1, float y1){
    AXValueRef temp;
    CGSize windowSize;
    CGPoint windowPosition;
    CFStringRef windowTitle;
    AXUIElementRef frontMostApp;
    AXUIElementRef frontMostWindow;
    
    frontMostApp = getFrontMostApp();
    
    AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, (CFTypeRef *)&frontMostWindow);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&windowTitle);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
    CFRelease(temp);
    
    AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
    AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
    CFRelease(temp);
    
    //printf("\n");
    CFShow(windowTitle);
    //printf("RESIZE: Window is at (%f, %f) and has dimensions of (%f, %f) resized to (%f, %f) according to (%f, %f, %f, %f)\n", windowPosition.x, windowPosition.y, windowSize.width, windowSize.height, x1-x, y1 - y, x, y, x1, y1);

    windowSize.width = x1;
    windowSize.height = y1;

    printf(" \n-- Resized window to dimensions: (%f, %f))\n\n", windowSize.width, windowSize.height);
    
    temp = AXValueCreate(kAXValueCGSizeType, &windowSize);
    AXUIElementSetAttributeValue(frontMostWindow, kAXSizeAttribute, temp);
    CFRelease(temp);
    CFRelease(frontMostWindow);
    CFRelease(frontMostApp);

}



