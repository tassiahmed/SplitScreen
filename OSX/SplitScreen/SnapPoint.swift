//
//  SnapPoint.swift
//  SplitScreen
//
//  Created by Evan Thompson on 3/4/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapPoint {
	
	fileprivate var snap_areas: [( (Int, Int), (Int, Int) )]
	fileprivate var screen_dimensions, snap_dimensions, snap_location: (Int, Int)
	
	/**
	Initializes the SnapPoint
	
	- Parameter screen_dim: The dimensions for the `Screen` the `SnapPoint` belongs to
	
	- Parameter snap_dim: The dimensions of the window when snapping from this `SnapPoint`
	
	- Parameter snap_loc: The location of the window upon snapping
	*/
	init(screen_dim: (Int, Int), snap_dim: (Int, Int), snap_loc: (Int, Int)) {
		snap_areas = []
		screen_dimensions = screen_dim
		snap_dimensions = snap_dim
		snap_location = snap_loc
	}
	
	
	/**
	Adds a new area for the SnapPoint to trigger
	NOTE: At least 1 value in both `first` and `second` must be `0`
	
	- Parameter first: top left corner of the area
	
	- Parameter second: bottom right corner of the area
	*/
	func add_snap_point(first: (Int, Int), second: (Int, Int)) {
		if first.0 > second.0 || first.1 > second.1 {
			return
		}
		snap_areas.append( (first, second) )
	}
	
	/**
	Checks to see if the point falls under any of the snap areas
	
	- Parameter x: `x` coordinate of the point
	
	- Parameter y: `y` coordinate of the point
	
	- Returns: `true` if the point `(x, y)` falls in any snap_area; `false` otherwise
	*/
	func check_point(x: Int, y: Int) -> Bool {
		let (width_factor, height_factor) = get_scale_factors()
		
		for snap_area in snap_areas {
			if x < snap_area.0.0 * width_factor || x > snap_area.1.0 * width_factor {
				continue
			}
			if y < snap_area.0.1 * height_factor || y > snap_area.1.1 * height_factor {
				continue
			}
			return true
		}
		return false
	}
	
	/**
	- Returns: `tuple` of `(Int, Int)` of the scaled top-left corner of `SnapPoint`
	*/
	func get_snap_location() -> (Int, Int) {
		let (width_factor, height_factor) = get_scale_factors()
		
		return ( snap_location.0 * width_factor, snap_location.1 * height_factor )
	}
	
	/**
	- Returns: `tuple` of `(Int, Int)` of the scaled dimensions of `SnapPoint`
	*/
	func get_snap_dimensions() -> (Int, Int) {
		let (width_factor, height_factor) = get_scale_factors()
		
		return ( snap_dimensions.0 * width_factor, snap_dimensions.1 * height_factor )
	}
	
	/**
	- Returns: `tuple` of `(Int, Int)` SnapPoint's corresponding `Screen` resolution
	*/
	func get_orig_screen_resolution() -> (Int, Int) {
		return screen_dimensions
	}
	
	/**
	- Returns: `String` representation of the `SnapPoint`
	*/
	func to_string() -> String {
		var result: String = String()
		
		result += get_string_scalar_rep(scalar: snap_dimensions.0,
		                                original: screen_dimensions.0,
		                                original_string: "WIDTH")
		
		result.append(",")
		result += get_string_scalar_rep(scalar: snap_dimensions.1,
		                                original: screen_dimensions.1,
		                                original_string: "HEIGHT")
		
		result.append(",")
		result += get_string_scalar_rep(scalar: snap_location.0,
		                                original: screen_dimensions.0,
		                                original_string: "WIDTH")
		
		result.append(",")
		result += get_string_scalar_rep(scalar: snap_location.1,
		                                original: screen_dimensions.1,
		                                original_string: "HEIGHT")
		
		for snap_area in snap_areas {
			result.append(",")
			result += get_string_point(point: snap_area.0)
			result.append(":")
			result += get_string_point(point: snap_area.1)
		}
		result.append("\n" as Character)
		return result
	}
	
	
	//*************************************************
	//               Private Functions
	//*************************************************
	
	/**
	- Returns: `tuple` of `(Int, Int)` of sacle factors for resolution adjustments
	*/
	fileprivate func get_scale_factors() -> (Int, Int) {
		let width_factor = CGFloat(screen_dimensions.0)/(NSScreen.main()?.frame.width)!
		let height_factor = CGFloat(screen_dimensions.1)/(NSScreen.main()?.frame.height)!
		
		return (Int(width_factor), Int(height_factor))
	}
	
	/**
	Returns the scalar's `String` representation of the value relative the value of `original`
	
	- Parameter scalar: `Int` that is a variable value of the SnapPoint
	
	- Parameter original: `Int` that corresponds to either the screen's width or height
	
	- Parameter original_string: `String` representation of the `original` value; either WIDTH or HEIGHT
	
	- Returns: `String` that represents the scalar in terms of its relationship to `original`
	*/
	fileprivate func get_string_scalar_rep(scalar: Int,
	                                       original: Int,
	                                       original_string: String) -> String {
		if scalar == 0 {
			return "0"
		} else if (scalar + 1) == original {
			return "\(original_string)-1"
		} else if original == scalar {
			return "\(original_string)"
		}
		
		let scale = Int(float_t(original)/float_t(scalar))
		return "\(original_string)/\(scale)"
	}
	
	/**
	Returns a `String` that stands for the snap locations of the `SnapPoint`
	
	- Parameter point: `tuple` that corresponds to a snap coordinate
	
	- Returns: `String` that represents the snap location
	*/
	
	fileprivate func get_string_point(point: (Int, Int)) -> String {
		let scalar_x = get_string_scalar_rep(scalar: point.0,
		                                     original: screen_dimensions.0,
		                                     original_string: "WIDTH")
		let scalar_y = get_string_scalar_rep(scalar: point.1,
		                                     original: screen_dimensions.1,
		                                     original_string: "HEIGHT")
		return "(\(scalar_x);\(scalar_y))"
	}
}
