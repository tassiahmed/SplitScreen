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

    struct point{
        var x = 0;
        var y = 0;
    }
    // How to resize the hardpoint
    private struct hardpoint_resize {
        var upper_left_corner = point()
        var lower_right_corner = point()
    }
	
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
    
    // Load layout from file
    func load(file_path: NSString){
        
//        var p1 = point()
//        p1.x = 0
//        p1.y = 0
//        var p1_r = hardpoint_resize()
//        var hp1 = point()
//        hp1.x = 0
//        hp1.y = HEIGHT/2
//        var hp2 = point()
//        hp2.x = WIDTH/2
//        hp2.y = 0
//        p1_r.upper_left_corner = hp1
//        p1_r.lower_right_corner = hp2
//        
//        hardpoints.append((p1, p1_r)) // Bottom left corner of the screen
		
		hardpoints.append(create_hardpoint((0, 0), hp1: (0, HEIGHT/2), hp2: (WIDTH/2, 0)))
		
//        var p2 = point()
//        p2.x = 0
//        p2.y = HEIGHT
//        
//        var p2_r =  hardpoint_resize()
//        var hp3 = point()
//        hp3.x = 0
//        hp3.y = 0
//        var hp4 = point()
//        hp4.x = WIDTH/2
//        hp4.y = HEIGHT/2
//        p2_r.lower_right_corner = hp4
//        p2_r.upper_left_corner = hp3
//        
//        hardpoints.append((p2, p2_r)) // Top left corner of the screen
		
		hardpoints.append(create_hardpoint((0, HEIGHT), hp1: (0, 0), hp2: (WIDTH/2, HEIGHT/2)))
		
//        var p3 = point()
//        p3.x = WIDTH
//        p3.y = 0
//        
//        var p3_r =  hardpoint_resize()
//        var hp5 = point()
//        hp5.x = WIDTH/2
//        hp5.y = HEIGHT/2
//        var hp6 = point()
//        hp6.x = WIDTH
//        hp6.y = 0
//        p3_r.lower_right_corner = hp6
//        p3_r.upper_left_corner = hp5
//        
//        hardpoints.append((p3, p3_r)) // Bottom right corner of the screen
		
		hardpoints.append(create_hardpoint((WIDTH, 0), hp1: (WIDTH/2, HEIGHT/2), hp2: (WIDTH, 0)))
		
//        var p4 = point()
//        p4.x = WIDTH
//        p4.y = HEIGHT
//        
//        var p4_r =  hardpoint_resize()
//        var hp7 = point()
//        hp7.x = WIDTH/2
//        hp7.y = 0
//        var hp8 = point()
//        hp8.x = WIDTH
//        hp8.y = HEIGHT/2
//        p4_r.lower_right_corner = hp8
//        p4_r.upper_left_corner = hp7
//        
//        hardpoints.append((p4, p4_r)) // Top right corner of the screen
		
		hardpoints.append(create_hardpoint((WIDTH, HEIGHT), hp1: (WIDTH/2, 0), hp2: (WIDTH, HEIGHT/2)))
    }
    
    // Checks if the location given is a hard point
    func is_hardpoint(x: CGFloat, y: CGFloat) -> Bool{
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
    
    // Returns x, y, x_size, y_size
    func get_snap_dimensions(x: CGFloat, y: CGFloat) ->(Int,Int,Int,Int){
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