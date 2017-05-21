//
//  NewSnapLayout.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 5/15/17.
//  Copyright © 2017 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class NewSnapLayout {
	fileprivate var snapPoints = [NewSnapPoint]()
	fileprivate var HEIGHT: Int = Int((NSScreen.main()?.frame.height)!)
	fileprivate var WIDTH: Int = Int((NSScreen.main()?.frame.width)!)
	
	/**
		Checks to see if the given `x` and `y` points are a `SnapPoint`
	
		- Parameter x: Screen's x coordinate that will be compared
	
		- Parameter y: Screen's y coordinate that will be compared
	
		- Returns: `true` or `false` if `x` and `y` both compare to an existing `SnapPoint`
	*/
	func isSnapPoint(x: CGFloat, y: CGFloat) -> Bool {
		let convertedX: Int = Int(x)
		let convertedY: Int = Int(y)
		
		for snapPoint in snapPoints {
			if snapPoint.inSnapArea(x: convertedX, y: convertedY) {
				return true
			}
		}
		return false
	}
	
	
	/**
		Get the resize dimensions and location for a dragged window
	
		- Parameter x: `CGFloat` that corresponds to screen x coordinate of mouse
	
		- Parameter y: `CGFloat` that corresponds to screen y coordinate of mouse
	
		- Returns: `tuple` pair of 2 `Ints` that correspond to the new location and dimensions
	*/
	func getResizeDimensions(x: CGFloat, y: CGFloat) -> ( (Int, Int), (Int, Int) ) {
		let convertedX: Int = Int(x)
		let convertedY: Int = Int(y)
		
		for snapPoint in snapPoints {
			if snapPoint.inSnapArea(x: convertedX, y: convertedY) {
				return (snapPoint.getSnapLocation(), snapPoint.getSnapDimensions())
			}
		}
		
		return ((-1, -1), (-1, -1))
	}
	
	//*************************************************
	//               Private Functions
	//*************************************************
	
	/**
		Creates `SnapPoint` objects and adds them to the SnapLayout in order to make it behave
		according the standard layout
	*/
	func standardLayout() {
		let topLeft: NewSnapPoint = NewSnapPoint.init(snapArea: ((0, HEIGHT), (0, HEIGHT)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT/2),
		                                              snapLocation: (0, 0))
		snapPoints.append(topLeft)
		
		let botLeft: NewSnapPoint = NewSnapPoint.init(snapArea: ((0, 0), (0, 0)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT/2),
		                                              snapLocation: (0, HEIGHT/2))
		snapPoints.append(botLeft)
		
		let leftSide: NewSnapPoint = NewSnapPoint.init(snapArea: ((0, 0), (0, HEIGHT)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT),
		                                              snapLocation: (0, 0))
		snapPoints.append(leftSide)
		
		let topRight: NewSnapPoint = NewSnapPoint.init(snapArea: ((WIDTH, HEIGHT), (WIDTH, HEIGHT)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT/2),
		                                              snapLocation: (WIDTH/2, 0))
		snapPoints.append(topRight)
		
		let botRight: NewSnapPoint = NewSnapPoint.init(snapArea: ((WIDTH, 0), (WIDTH, 0)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT/2),
		                                              snapLocation: (WIDTH/2, HEIGHT/2))
		snapPoints.append(botRight)
		
		let rightSide: NewSnapPoint = NewSnapPoint.init(snapArea: ((WIDTH, 0), (WIDTH, HEIGHT)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH/2, HEIGHT),
		                                              snapLocation: (WIDTH/2, 0))
		snapPoints.append(rightSide)
		
		let top: NewSnapPoint = NewSnapPoint.init(snapArea: ((0, HEIGHT), (WIDTH, HEIGHT)),
		                                              screenDimensions: (WIDTH, HEIGHT),
		                                              snapDimensions: (WIDTH, HEIGHT),
		                                              snapLocation: (0, 0))
		snapPoints.append(top)
	}
}
