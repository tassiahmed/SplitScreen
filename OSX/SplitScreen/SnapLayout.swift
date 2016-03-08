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

    //******
    
    var snap_points = [SnapPoint]()
    
    //******
    
	/**
		Loads a file at `file_path` with preset hardpoints
	
		- Parameter file_path: `NSString` that corresponds to a file with preset hardpoints
	*/
    func load(file_path: NSString) {
        
        HEIGHT = Int((NSScreen.mainScreen()?.frame.height)!)
        WIDTH = Int((NSScreen.mainScreen()?.frame.width)!)
		
        // Need file I/O here
        
        // hardcoded windows 10 aerosnap
        let top_left: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT/2, x_snap_loc: 0, y_snap_loc: 0, log: 0)
        top_left.add_snap_point(0, y0: HEIGHT, x1: 0, y1: HEIGHT)
        
        snap_points.append(top_left)
        
        let bot_left: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT/2, x_snap_loc: 0, y_snap_loc: HEIGHT/2, log: 0)
        bot_left.add_snap_point(0, y0: 0, x1: 0, y1: 0)
        
        snap_points.append(bot_left)
        
        let left_side: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT, x_snap_loc: 0, y_snap_loc: 0, log: 0)
        left_side.add_snap_point(0, y0: 1, x1: 0, y1: HEIGHT - 1)
        
        snap_points.append(left_side)
        
        let top_right: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT/2, x_snap_loc: WIDTH/2, y_snap_loc: 0, log: 0)
        top_right.add_snap_point(WIDTH, y0: HEIGHT, x1: WIDTH, y1: HEIGHT)
        
        snap_points.append(top_right)
        
        let bot_right: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT/2, x_snap_loc: WIDTH/2, y_snap_loc: HEIGHT/2, log: 0)
        bot_right.add_snap_point(WIDTH, y0: 0, x1: WIDTH, y1: 0)
        
        snap_points.append(bot_right)
        
        let right_side: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH/2, y_dim: HEIGHT, x_snap_loc: WIDTH/2, y_snap_loc: 0, log: 0)
        right_side.add_snap_point(WIDTH, y0: 1, x1: WIDTH, y1: HEIGHT - 1)
        
        snap_points.append(right_side)
        
        let top: SnapPoint = SnapPoint.init(height: HEIGHT, width: WIDTH, x_dim: WIDTH, y_dim: HEIGHT, x_snap_loc: 0, y_snap_loc: 0, log: 0)
        top.add_snap_point(1, y0: HEIGHT, x1: WIDTH-1, y1: HEIGHT)
        
        snap_points.append(top)
        
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
        
        for var i = 0; i < snap_points.count; ++i {
            if snap_points[i].check_point(x_i, y: y_i) {
                let (x_snap, y_snap) = snap_points[i].get_snap_location()
                let (x_dim, y_dim) = snap_points[i].get_dimensions()
                return (x_snap, y_snap, x_dim, y_dim)
            }
        }
        
        //should never reach this point
        return (-1,-1,-1,-1)
    }
    
    let menu = NSApplication.sharedApplication().mainMenu
    private var HEIGHT: Int = Int((NSScreen.mainScreen()?.frame.height)!)
    private var WIDTH: Int = Int((NSScreen.mainScreen()?.frame.width)!)
}