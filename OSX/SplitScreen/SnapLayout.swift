//
//  SnapLayout.swift
//  SplitScreen
//
//  Created by Evan Thompson on 10/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapLayout {

	/**
		`struct` that corresponds to a screen coordinate
	*/
    struct point {
        var x = 0;
        var y = 0;
    }
	
	/**
		`struct` that contains `points` that will resize a window
	*/
    private struct hardpoint_resize {
        var upper_left_corner = point()
        var lower_right_corner = point()
    }
	
	/**
		Creates a new hardpoint given the parameters for window resizing
	
		- Parameter p1: `tuple` corresponding to point that will be where the user will drag the window to resize it
	
		- Parameter hp1: `tuple` corresponding to the new top left corner position of the dragged window
	
		- Parameter hp2: `tuple` corresponding to the new bottom right corner position fo the dragged window
	
		- Returns: `tuple` that contains a `point` and a `hardpoint_resize`
	*/
	private func create_hardpoint(p1: (Int, Int),
									hp1: (Int, Int),
									hp2: (Int, Int)) -> (point, hardpoint_resize) {
		var first_point = point()
		first_point.x = p1.0
		first_point.y = p1.1
		
		var first_point_resize = hardpoint_resize()
		
		var resize_left_corner = point()
		resize_left_corner.x = hp1.0
		resize_left_corner.y = hp1.1
		
		var resize_right_corner = point()
		resize_right_corner.x = hp2.0
		resize_right_corner.y = hp2.1
		
		first_point_resize.upper_left_corner = resize_left_corner
		first_point_resize.lower_right_corner = resize_right_corner
		
		return (first_point, first_point_resize)
	}
    
	/**
		Loads a file at `file_path` with preset hardpoints
	
		- Parameter file_path: `NSString` that corresponds to a file with preset hardpoints
	*/
    func load(file_path: NSString) {
		
		// Bottom left corner of the screen
		hardpoints.append(create_hardpoint((0, 0), hp1: (0, HEIGHT/2), hp2: (WIDTH/2, 0)))
		
		// Top left corner of the screen
		hardpoints.append(create_hardpoint((0, HEIGHT), hp1: (0, 0), hp2: (WIDTH/2, HEIGHT/2)))
		
		// Bottom right corner of the screen
		hardpoints.append(create_hardpoint((WIDTH, 0), hp1: (WIDTH/2, HEIGHT/2), hp2: (WIDTH, 0)))
		
		// Top right corner of the screen
		hardpoints.append(create_hardpoint((WIDTH, HEIGHT), hp1: (WIDTH/2, 0), hp2: (WIDTH, HEIGHT/2)))
    }
    
	/**
		Checks to see if the given `x` and `y` points are hardpoints
	
		- Parameter x: Screen's x coordinate that will be compared
	
		- Paramter y: Screen's y coordinate that will be compared
	
		- Returns: `true` or `false` if `x` and `y` both compare to an existing hardpoint
	*/
    func is_hardpoint(x: CGFloat, y: CGFloat) -> Bool {
        let xpos:Int = Int(x + 0.5)
        let ypos:Int = Int(y + 0.5)
        for var i = 0; i < hardpoints.count; ++i{
            if xpos == hardpoints[i].0.x && ypos == hardpoints[i].0.y {
                return true
            }
            if xpos == 0 || xpos == WIDTH {
                return true
            }
            if ypos == HEIGHT {
                return true
            }
        }
        
        return false
    }
    
	/**
		Get the new dimensions for a dragged window
	
		- Parameter x: `CGFloat` that corresponds to screen x coordinate of mouse
	
		- Parameter y: `CGFloat` that corresponds to screen y coordinate of mouse
	
		- Returns: `tuple` of 4 `Ints` that correspond to the dragged windows four corners 
	*/
    func get_snap_dimensions(x: CGFloat, y: CGFloat) ->(Int,Int,Int,Int) {
        let x_i:Int = Int(x + 0.5)
        let y_i:Int = Int(y + 0.5)
        for var i = 0; i < hardpoints.count; ++i{
            if x_i == hardpoints[i].0.x && y_i == hardpoints[i].0.y {
                
                // Fix height for the main menu bar
                if hardpoints[i].1.upper_left_corner.y == 0 {
                    return (hardpoints[i].1.upper_left_corner.x, Int(menu!.menuBarHeight), abs(hardpoints[i].1.upper_left_corner.x - hardpoints[i].1.lower_right_corner.x), abs(hardpoints[i].1.upper_left_corner.y - hardpoints[i].1.lower_right_corner.y))
                }
                
                return (hardpoints[i].1.upper_left_corner.x, hardpoints[i].1.upper_left_corner.y, abs(hardpoints[i].1.upper_left_corner.x - hardpoints[i].1.lower_right_corner.x), abs(hardpoints[i].1.upper_left_corner.y - hardpoints[i].1.lower_right_corner.y))
            }
        }
        
        // Check if location is on a side
        if x_i == 0 {
            return (0,Int(menu!.menuBarHeight),WIDTH/2,HEIGHT)
        }
        else if x_i == WIDTH {
            return (WIDTH/2,Int(menu!.menuBarHeight),WIDTH/2,HEIGHT)
        }
        
        // Check if location is on top of screen
        if y_i == HEIGHT {
            return (0,Int(menu!.menuBarHeight),WIDTH, HEIGHT)
        }
        
        return (0,0,0,0)
    }
    
    let menu = NSApplication.sharedApplication().mainMenu
    private var hardpoints = [(point, hardpoint_resize)]()
    private let HEIGHT: Int = Int((NSScreen.mainScreen()?.frame.height)!)
    private let WIDTH: Int = Int((NSScreen.mainScreen()?.frame.width)!)
}