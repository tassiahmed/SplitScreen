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
	
    var snap_points = [SnapPoint]()
	
	/**
		Creates `SnapPoint` objects and adds them to the SnapLayout in order to make it behave
		according the standard layout
	*/
    func standard_layout(){
        HEIGHT = Int((NSScreen.main()?.frame.height)!)
        WIDTH = Int((NSScreen.main()?.frame.width)!)
		
        // Hardcoded Windows 10 Aero Snap
		let top_left: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT/2),
		                                         snap_loc: (0, 0))
		top_left.add_snap_point(first: (0, HEIGHT), second: (0 ,HEIGHT))
        
        snap_points.append(top_left)
		
		let bot_left: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT/2),
		                                         snap_loc: (0, HEIGHT/2))
		bot_left.add_snap_point(first: (0, 0), second: (0, 0))
        
        snap_points.append(bot_left)
		
		let left_side: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT),
		                                         snap_loc: (0, 0))
		left_side.add_snap_point(first: (0, 1), second: (0, HEIGHT-1))
        
        snap_points.append(left_side)
		
		let top_right: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT/2),
		                                         snap_loc: (WIDTH/2, 0))
		top_right.add_snap_point(first: (WIDTH, HEIGHT), second: (WIDTH, HEIGHT))
        
        snap_points.append(top_right)
		
		let bot_right: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT/2),
		                                         snap_loc: (WIDTH/2, HEIGHT/2))
		bot_right.add_snap_point(first: (WIDTH, 0), second: (WIDTH, 0))
        
        snap_points.append(bot_right)
		
		let right_side: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH/2, HEIGHT),
		                                         snap_loc: (WIDTH/2, 0))
		right_side.add_snap_point(first: (WIDTH, 1), second: (WIDTH, HEIGHT-1))
        
        snap_points.append(right_side)
		
		let top: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH, HEIGHT),
		                                         snap_loc: (0, 0))
		top.add_snap_point(first: (1, HEIGHT), second: (WIDTH-1, HEIGHT))
        
        snap_points.append(top)
    }
	
	/**
		Creates `SnapPoint` objects and adds them to the SnapLayout in order to make it behave
		according the horizontal layout
	*/
    func horizontal_layout(){
		
		let left_upper: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH, HEIGHT/2),
		                                         snap_loc: (0, 0))
		left_upper.add_snap_point(first: (0, HEIGHT/2), second: (0, HEIGHT))
        
        snap_points.append(left_upper)
		
		let left_lower: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH, HEIGHT/2),
		                                         snap_loc: (0, HEIGHT/2))
		left_lower.add_snap_point(first: (0, 0), second: (0, HEIGHT/2))
        
        snap_points.append(left_lower)
		
		let right_upper: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH, HEIGHT/2),
		                                         snap_loc: (0, 0))
		right_upper.add_snap_point(first: (WIDTH, HEIGHT/2), second: (WIDTH, HEIGHT))
        
        snap_points.append(right_upper)
		
		let right_lower: SnapPoint = SnapPoint.init(screen_dim: (WIDTH, HEIGHT),
		                                         snap_dim: (WIDTH, HEIGHT/2),
		                                         snap_loc: (0, HEIGHT/2))
		right_lower.add_snap_point(first: (WIDTH, 0), second: (WIDTH, HEIGHT/2))
        
        snap_points.append(right_lower)
    }
    
    
	/**
		Loads a file at `file_path` with preset hardpoints
	
		- Parameter file_path: `NSString` that corresponds to a file with preset hardpoints
	*/
    func load(_ template_name: NSString) {
		
        // Refreshes the snap points
        snap_points.removeAll()
        
        if(template_name == "standard") {
            standard_layout()
        } else if(template_name == "horizontal") {
            horizontal_layout()
        }
    }
    
	/**
		Checks to see if the given `x` and `y` points are hardpoints
	
		- Parameter x: Screen's x coordinate that will be compared
	
		- Paramter y: Screen's y coordinate that will be compared
	
		- Returns: `true` or `false` if `x` and `y` both compare to an existing hardpoint
	*/
    func is_hardpoint(_ x: CGFloat, y: CGFloat) -> Bool {
        let xpos:Int = Int(x + 0.5)
        let ypos:Int = Int(y + 0.5)
        for i in 0 ..< snap_points.count {
			if snap_points[i].check_point(x: xpos, y: ypos) {
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
    func get_snap_dimensions(_ x: CGFloat, y: CGFloat) ->(Int,Int,Int,Int) {
        let x_i:Int = Int(x + 0.5)
        let y_i:Int = Int(y + 0.5)
        
        for i in 0 ..< snap_points.count {
			if snap_points[i].check_point(x: x_i, y: y_i) {
                let (x_snap, y_snap) = snap_points[i].get_snap_location()
                let (x_dim, y_dim) = snap_points[i].get_snap_dimensions()
                return (x_snap, y_snap, x_dim, y_dim)
            }
        }
        
        // Should never reach this point
        return (-1,-1,-1,-1)
    }
	
	
	/**
		Creates and returns a string representation of the SnapLayout
	
		- Returns: `String` which represents the SnapLayout
	*/
	func toString() -> String {
		var retString: String = String()
		for snap_point in snap_points {
			retString = retString + snap_point.to_string()
		}
		return retString
	}
    
    let menu = NSApplication.shared().mainMenu
    fileprivate var HEIGHT: Int = Int((NSScreen.main()?.frame.height)!)
    fileprivate var WIDTH: Int = Int((NSScreen.main()?.frame.width)!)
}
