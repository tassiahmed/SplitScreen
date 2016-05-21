//
//  SnapPoint.swift
//  SplitScreen
//
//  Created by Evan Thompson on 3/4/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapPoint{
    
    private var snap_point = [((Int,Int),(Int,Int))]() // All snap locations that can snap to a point
    private var snap_location: (Int, Int)
    private var dimensions: (Int, Int)
    private var logic: Int
    private var orig_height: Int
    private var orig_width: Int
    
    /**
        Initializes this SnapPoint
     
        Parameters:
        
        height - the original height this layout was designed for
     
        width - the original width this layout was designed for
     
        x_dim - the x dimension of the resize
     
        y_dim - the y dimension of the resize
     
        x_snap_loc - the x-coordinate of where the window will be moved to
     
        y_snap_loc - the y-coordinate of where the window will be moved to
     
        log - the logic bit to determine what action will be performed by the snap
     */
    init(height: Int, width: Int, x_dim: Int, y_dim: Int, x_snap_loc: Int, y_snap_loc: Int, log: Int) {
        snap_location = (x_snap_loc, y_snap_loc)
        dimensions = (x_dim,y_dim)
        logic = log
        orig_height = height
        orig_width = width
    }
    
    /**
        Adds a new snap_point definition
     
        Parameters:
     
        x0 - left x-coordinate
        
        y0 - low y-coordinate
     
        x1 - right x-coordinate
     
        y1 - high y-coordinate
     
        [NOTE: at least one number in the pairings of x0,y0 and x1,y1 must be 0]
     
    */
    func add_snap_point(x0: Int, y0: Int, x1: Int, y1: Int) -> Bool {
        
        if x0 > x1 || y0 > y1 {
            return false
        }
        
        snap_point.append(((x0, y0),(x1, y1)))
        return true
    }
    
    
    /**
        Checks if a location falls under this snap point
     
        Parameters: 
        
        x - x value of location to check
     
        y - y value of location to check
     */
    func check_point(x: Int, y: Int) -> Bool {
        
        let (scale_factor_h, scale_factor_w) = get_scale_factors()
        
        // Run through each snap_point and check if it fits the guessed location
        for snaps in snap_point{
            
//            print("snap_point scaled: x0: \(CGFloat(snaps.0.0) * scale_factor_w) x1: \(CGFloat(snaps.1.0) * scale_factor_w) y0: \(CGFloat(snaps.0.1) * scale_factor_h) y1: \(CGFloat(snaps.1.1) * scale_factor_h)")
//            
            if x >= Int(CGFloat(snaps.0.0) * scale_factor_w) && x <= Int(CGFloat(snaps.1.0) * scale_factor_w) && y >= Int(CGFloat(snaps.0.1) * scale_factor_h) && y <= Int(CGFloat(snaps.1.1) * scale_factor_h) {
//                print(" - falls in range (\(x),\(y))")
                return true
            }
            
        }
        return false
    }
    
    
    /**
        Returns scaled snap_location value (left hand corner of the snap)
	
		- Returns: `tuple` of `Int` that is the scaled left hand corner of the snap location
     */
    func get_snap_location() -> (Int, Int) {
        let (scale_factor_h, scale_factor_w) = get_scale_factors()
        
        return (Int(CGFloat(snap_location.0) * scale_factor_w), Int(CGFloat(snap_location.1) * scale_factor_h))

    }
    
    /**
        Returns scaled dimensions of `SnapPoint`
	
		- Returns: `tuple` of `Int` that is the scaled dimensions of `SnapPoint`
     */
    func get_dimensions() -> (Int, Int) {
        
        let (scale_factor_h, scale_factor_w) = get_scale_factors()
        
        return (Int(CGFloat(dimensions.0) * scale_factor_w), Int(CGFloat(dimensions.1) * scale_factor_h))
    }
    
    /**
        Returns the logic associated with the snap
	
		- Returns: `Int` that corresponds to the logic behind the snap behavior
     */
    func get_logic() -> Int {
        return Int(logic)
    }

    /**
        Returns the resolution (height, width) that this layout was made with
     
        NOTE: Use for scaling purposes with different resolutions
	
		- Returns: `tuple` of `Int` that is the original resolution the `SnapPoint` was made with
     */
    func get_orig_resolution() -> (Int, Int){
        return (Int(orig_height), Int(orig_width))
	}
	
	/**
		Returns the scalar's `String` representation of the value relative the value of `original`
	
		- Parameter scalar: `Int` that is a variable value of the SnapPoint
	
		- Parameter original: `Int` that corresponds to either the screen's width or height
	
		- Parameter original_string: `String` representation of the `original` value; either WIDTH or HEIGHT
	
		- Returns: `String` that represents the scalar in terms of its relationship to `original`
	*/
	func get_string_scalar_representation(scalar: Int, original: Int, original_string: String) -> String {
		if scalar == 0 {
			return "0"
		}
		if (scalar + 1) == original {
			return "\(original_string)-1"
		}
		if original == scalar {
			return "\(original_string)"
		}
		
		let scale = original/scalar
		return "\(original_string)/\(scale)"
	}
	
	/**
		Returns a `String` that stnads for the snap locations of the `SnapPoint`
	
		- Parameter point: `tuple` that corresponds to a snap coordinate
	
		- Parameter height: `Int` that corresponds to screen's height
	
		- Parameter width: `Int` that corresponds to screen's width
	
		- Returns: `String` that represents the snap location
	*/
	func get_string_snap_point(point: (Int,Int), height: Int, width: Int) -> String {
		let scalar_x = get_string_scalar_representation(point.0, original: width, original_string: "WIDTH")
		let scalar_y = get_string_scalar_representation(point.1, original: height, original_string: "HEIGHT")
		return "(\(scalar_x);\(scalar_y))"
	}

	/**
		Return the `String` representation of the `SnapPoint`
	
		- Parameter screenHeight: `Int` that corresponds to the screen's height
	
		- Parameter screenWdith: `int` that corresponds to the screen's width
	
		- Returns: `String` that represents the SnapPoint
	*/
	func get_string_representation(screenHeight: Int, screenWidth: Int) -> String {
		var ret_String: String = String()
		// Add in Screen Height
		ret_String = ret_String.stringByAppendingString("HEIGHT")
		ret_String.append("," as Character)
		
		// Add in Screen Width
		ret_String = ret_String.stringByAppendingString("WIDTH")
		ret_String.append("," as Character)
		
		// Add in x-axis resize dimension
		ret_String = ret_String.stringByAppendingString(
			self.get_string_scalar_representation(dimensions.0,
				original: screenWidth,
				original_string: "WIDTH"))
		
		// Add in y-axis resize dimension
		ret_String.append("," as Character)
		ret_String = ret_String.stringByAppendingString(
			self.get_string_scalar_representation(dimensions.1,
				original: screenHeight,
				original_string: "HEIGHT"))
		
		// Add in x-axis snape location
		ret_String.append("," as Character)
		ret_String = ret_String.stringByAppendingString(
			self.get_string_scalar_representation(snap_location.0,
				original: screenWidth,
				original_string: "WIDTH"))
		
		// Add in y-axis snap location
		ret_String.append("," as Character)
		ret_String = ret_String.stringByAppendingString(
			self.get_string_scalar_representation(snap_location.1,
				original: screenHeight,
				original_string: "HEIGHT"))
		
		// Add in logic for the `SnapPoint`
		ret_String.append("," as Character)
		ret_String = ret_String.stringByAppendingString(String(logic))
		
		// Add in the tuples for snap points
		for point in snap_point {
			ret_String.append("," as Character)
			ret_String = ret_String.stringByAppendingString(get_string_snap_point(point.0,
				height: screenHeight,
				width: screenWidth))
			ret_String.append(":" as Character)
			ret_String = ret_String.stringByAppendingString(get_string_snap_point(point.1,
				height: screenHeight,
				width: screenWidth))
		}
		ret_String.append("\n" as Character)
		return ret_String
	}
	
    //*************************************************
    //               Private Functions
    //*************************************************
    
    /**
        INTERNAL
            
        returns the scale factor for the dimensions and snap locations
	
		- Returns: `tuple` of `CGFloat` that is the scale factor to use for the current machine
     */
    private func get_scale_factors() -> (CGFloat, CGFloat){
        let curr_height: Int = Int((NSScreen.mainScreen()?.frame.height)!)
        let curr_width: Int = Int((NSScreen.mainScreen()?.frame.width)!)
        
        return (CGFloat(curr_height)/CGFloat(orig_height), CGFloat(curr_width)/CGFloat(orig_width))
    }
    
}