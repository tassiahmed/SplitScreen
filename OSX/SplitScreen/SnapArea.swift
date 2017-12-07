//
//  SnapArea.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 12/7/17.
//  Copyright © 2017 SplitScreen. All rights reserved.
//

import Foundation

class SnapArea {
	
	fileprivate var area: ((Int, Int), (Int, Int))
	fileprivate var screenDimensions, snapDimensions, snapLocation: (Int, Int)
	
	/**
		Initializes a new SnapArea
	
		- Parameter area: `tuple` containing 2 `tuples`  corresponding to `(x, y)` coordinates. `area.0` is bottom-left coordinate and `area.1` is top-right coordinate
		- Parameter screenDimensions: `tuple` that contains `(width, height)` for `Screen` that this `SnapArea` is contained within
		- Parameter snapDimensions: `tuple` that contains `(width, height)` for new dimensions after snapping
		- Parameter snapLocation: `tuple` that contains `(x, y)` for where the window will snap to
	*/
	init(area: ((Int, Int), (Int, Int)), screenDimensions: (Int, Int), snapDimensions: (Int, Int),
			 snapLocation: (Int, Int)) {
		self.area = area
		self.screenDimensions = screenDimensions
		self.snapDimensions = snapDimensions
		self.snapLocation = snapLocation
	}
	
	/**
			Determines if `(x, y)` pair is in the `SnapArea`
	
			- Parameter x: `x` coordinate
	
			- Parameter y: `y` coordinate
	
			- Returns: `true` if the point `(x, y)` falls in the `SnapArea`; `false` otherwise
	*/
	func inSnapArea(x: Int, y: Int) -> Bool {
		updatePoints()
		if x < area.0.0 || x > area.1.0 {
			return false
		}
		if y < area.0.1 || y > area.1.1 {
			return false
		}
		
		return true
	}
	
	/**
			- Returns: `tuple` of `(Int, Int)` of the scaled top-left corner of `SnapArea`
	*/
	func getSnapLocation() -> (Int, Int) {
		updatePoints()
		return (snapLocation.0, snapLocation.1)
	}
	
	/**
			- Returns: `tuple` of `(Int, Int)` of the scaled snapping dimensions of `SnapArea`
	*/
	func getSnapDimensions() -> (Int, Int) {
		updatePoints()
		return (snapDimensions.0, snapDimensions.1)
	}
	
	/**
			- Returns: `tuple` of `(Int, Int)` SnapPoint's corresponding `Screen` dimensions
	*/
	func getScreenDimension() -> (Int, Int) {
		updatePoints()
		return (screenDimensions.0, screenDimensions.1)
	}
	
	//*************************************************
	//							PRIVATE FUNCTIONS
	//*************************************************
	
	/**
			- Returns: `tuple` of `(Int, Int)` of scale factors for resolution adjustments
	*/
	fileprivate func getDimensionScalars() -> (Int, Int) {
		return (1, 1)
	}
	
	/**
			Updates all vars in `SnapArea` w/ respect to current `Screen`'s new resolution.
			Does not update if scalars are `1`
	*/
	fileprivate func updatePoints() {
		let (widthScalar, heightScalar) = getDimensionScalars()
		if widthScalar == 1 && heightScalar == 1 {
			return
		}
		
		area.0.0 *= widthScalar
		area.0.1 *= heightScalar
		area.1.0 *= widthScalar
		area.1.1 *= heightScalar
		
		screenDimensions.0 *= widthScalar
		screenDimensions.1 *= heightScalar
		
		snapDimensions.0 *= widthScalar
		snapDimensions.1 *= heightScalar
		
		snapLocation.0 *= widthScalar
		snapLocation.1 *= heightScalar
	}
}
