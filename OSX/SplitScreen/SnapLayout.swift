//
//  SnapLayout.swift
//  SplitScreen
//
//  Created by Evan Thompson on 10/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

import Foundation

class SnapLayout {
    
    private struct point{
        var x = 0;
        var y = 0;
        
        /*var hashValue: Int{
            get {
            
            }
        }*/
    }
    
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
        hp1.y = 0
        var hp2 = point()
        hp2.x = 525
        hp2.y = 840
        p1_r.upper_left_corner = hp1
        p1_r.lower_right_corner = hp2
        hardpoints.append((p1, p1_r))
    }
    
    //checks if the location given is a snap point
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
    func get_snap_dimensions(x: float_t, y: float_t) ->(Int,Int,Int,Int){
        return (0,0,400,400)
    }
    
    //private var hardpoints = Dictionary<point, hardpoint_resize>()
    private var hardpoints = [(point, hardpoint_resize)]()
}