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
        /*
        var p1 = point()
        p1.x = 0
        p1.y = 0
        var p1_r = hardpoint_resize()
        var hp1 = point()
        hp1.x = 0
        hp1.y = 0
        var hp2 = point()
        hp2.x = 525
        hp2.y = 840
        p1_r.upper_left_corner = hp1
        p1_r.lower_right_corner = hp2
        */
        hardpoints.append((p1, p1_r)) //bottom left corner of the screen
    }
    
    //checks if the location given is a hard point
    func is_hardpoint(x: CGFloat, y: CGFloat) -> Bool{
        let xpos:Int = Int(x)
        let ypos:Int = Int(y)
        
        for var i = 0; i < hardpoints.count; ++i{
            if xpos == hardpoints[i].0.x && ypos == hardpoints[i].0.y {
                return true
            }
        }
        
        return false
    }
    
    //returns x, y, x_size, y_size
    func get_snap_dimensions(x: CGFloat, y: CGFloat) ->(Int,Int,Int,Int){
        let x_i:Int = Int(x)
        let y_i:Int = Int(y)
        for var i = 0; i < hardpoints.count; ++i{
            if x_i == hardpoints[i].0.x && y_i == hardpoints[i].0.y{
                return (hardpoints[i].1.upper_left_corner.x, hardpoints[i].1.upper_left_corner.y, abs(hardpoints[i].1.upper_left_corner.x - hardpoints[i].1.lower_right_corner.x), abs(hardpoints[i].1.upper_left_corner.y - hardpoints[i].1.lower_right_corner.y))
            }
        }
        
        return (0,0,0,0)
    }
    
    private var hardpoints = [(point, hardpoint_resize)]()
    private let HEIGHT: Int = Int((NSScreen.mainScreen()?.frame.height)!)
    private let WIDTH: Int = Int((NSScreen.mainScreen()?.frame.width)!)
 //   private let (HEIGHT, WIDTH) = (NSScreen.mainScreen()?.frame.height, NSScreen.mainScreen()?.frame.width)
}