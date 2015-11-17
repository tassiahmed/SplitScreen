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
        
        /*var hashValue: Int{
            get {
            
            }
        }*/
    }
    //how to resize the hardpoint
    private struct hardpoint_resize{
        var upper_left_corner = point()
        var lower_right_corner = point()
    }
    
    //load layout from file
    func load(file_path: NSString){
        
        var p1 = point()
        p1.x = 0
        p1.y = 0
        var p1_r = hardpoint_resize()
        var hp1 = point()
        hp1.x = 0
        hp1.y = HEIGHT/2
        var hp2 = point()
        hp2.x = WIDTH/2
        hp2.y = 0
        p1_r.upper_left_corner = hp1
        p1_r.lower_right_corner = hp2
        
        hardpoints.append((p1, p1_r)) //bottom left corner of the screen
        
        var p2 = point()
        p2.x = 0
        p2.y = HEIGHT
        
        var p2_r =  hardpoint_resize()
        var hp3 = point()
        hp3.x = 0
        hp3.y = 0
        var hp4 = point()
        hp4.x = WIDTH/2
        hp4.y = HEIGHT/2
        p2_r.lower_right_corner = hp4
        p2_r.upper_left_corner = hp3
        
        hardpoints.append((p2, p2_r)) //top left corner of the screen
        
        var p3 = point()
        p3.x = WIDTH
        p3.y = 0
        
        var p3_r =  hardpoint_resize()
        var hp5 = point()
        hp5.x = WIDTH/2
        hp5.y = HEIGHT/2
        var hp6 = point()
        hp6.x = WIDTH
        hp6.y = 0
        p3_r.lower_right_corner = hp6
        p3_r.upper_left_corner = hp5
        
        hardpoints.append((p3, p3_r)) //bottom right corner of the screen
        
        var p4 = point()
        p4.x = WIDTH
        p4.y = HEIGHT
        
        var p4_r =  hardpoint_resize()
        var hp7 = point()
        hp7.x = WIDTH/2
        hp7.y = 0
        var hp8 = point()
        hp8.x = WIDTH
        hp8.y = HEIGHT/2
        p4_r.lower_right_corner = hp8
        p4_r.upper_left_corner = hp7
        
        hardpoints.append((p4, p4_r)) //top right corner of the screen
    }
    
    //checks if the location given is a hard point
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
    
    //returns x, y, x_size, y_size
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
 //   private let (HEIGHT, WIDTH) = (NSScreen.mainScreen()?.frame.height, NSScreen.mainScreen()?.frame.width)
}