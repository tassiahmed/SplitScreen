//
//  NewSnapPoint.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 5/15/17.
//  Copyright © 2017 SplitScreen. All rights reserved.
//

import Foundation

class NewSnapPoint {
	fileprivate var snapArea: ((Int, Int), (Int, Int))
	fileprivate var screenDimensions, snapDimensions, snapLocation: (Int, Int)
	
	/**
		Initializes the SnapPoint
	
		- Parameter snapArea: The area between 2 (x, y) coordinates where Snapping will be registered
	
		- Parameter screenDimensions: The dimensions for the `Screen` the `SnapPoint` belongs to
	
		- Parameter snapDimensions: The dimensions of the window when snapping from this `SnapPoint`
	
		- Parameter snapLocation: The location of the window upon snapping
	*/
	init(snapArea: ( (Int, Int), (Int, Int) ),
	     screenDimensions: (Int, Int),
	     snapDimensions: (Int, Int),
	     snapLocation: (Int, Int)) {
		self.snapArea = snapArea
		self.screenDimensions = screenDimensions
		self.snapDimensions = snapDimensions
		self.snapLocation = snapLocation
	}
	
	/**
		Checks to see if the point falls in the snapArea
	
		- Parameter x: `x` coordinate of the point
	
		- Parameter y: `y` coordinate of the point
	
		- Returns: `true` if the point `(x, y)` falls in the snapArea; `false` otherwise
	*/
	func inSnapArea(x: Int, y: Int) -> Bool {
		updateAllPoints()
		
		if x < snapArea.0.0 || x > snapArea.1.0 {
			return false
		}
		if y < snapArea.0.1 || y > snapArea.1.1 {
			return false
		}
		return true
	}
	
	/**
		- Returns: `tuple` of `(Int, Int)` of the scaled top-left corner of `SnapPoint`
	*/
	func getSnapLocation() -> (Int, Int) {
		updateAllPoints()
		return (snapLocation.0, snapLocation.1)
	}
	
	/**
		- Returns: `tuple` of `(Int, Int)` of the scaled snapping dimensions of `SnapPoint`
	*/
	func getSnapDimensions() -> (Int, Int) {
		updateAllPoints()
		return (snapDimensions.0, snapDimensions.1)
	}
	
	/**
		- Returns: `tuple` of `(Int, Int)` SnapPoint's corresponding `Screen` resolution
	*/
	func getScreenDimensions() -> (Int, Int) {
		updateAllPoints()
		return screenDimensions
	}
	
	//*************************************************
	//               Private Functions
	//*************************************************
	
	/**
		- Returns: `tuple` of `(Int, Int)` of scale factors for resolution adjustments
	*/
	fileprivate func getDimensionScalars() -> (Int, Int) {
		return (1, 1)
	}
	
	/**
		Updates all vars in `SnapPoint` to correspond to new dimensions of their corresponding screen.
		Does not update if no need to
	*/
	fileprivate func updateAllPoints() {
		let (widthScalar, heightScalar) = getDimensionScalars()
		if widthScalar == 1 && heightScalar == 1 {
			return
		}
		
		snapArea.0.0 *= widthScalar
		snapArea.0.1 *= heightScalar
		snapArea.1.0 *= widthScalar
		snapArea.1.1 *= heightScalar
		
		screenDimensions.0 *= widthScalar
		screenDimensions.1 *= heightScalar
		
		snapDimensions.0 *= widthScalar
		snapDimensions.1 *= heightScalar
		
		snapLocation.0 *= widthScalar
		snapLocation.1 *= widthScalar
	}
}
