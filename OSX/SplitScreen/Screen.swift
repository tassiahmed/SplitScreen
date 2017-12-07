//
//  Screen.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 9/11/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class Screen {
	
	fileprivate var snapLayout: NewSnapLayout
	fileprivate var bottomLeft, dimensions, topRight: (Int, Int)
	
	init() {
		snapLayout = layout
		bottomLeft = (0,0)
		dimensions = (0,0)
		topRight = (0,0)
	}
	
	init(screen: NSScreen) {
		snapLayout = layout
		bottomLeft = (Int(screen.frame.origin.x), Int(screen.frame.origin.y))
		dimensions = (Int(screen.frame.size.width), Int(screen.frame.size.height))
		topRight = (bottomLeft.0 + dimensions.0, bottomLeft.1 + dimensions.1)
	}
	
	func setSnapLayout(layout: NewSnapLayout) {
		snapLayout = layout
	}
	
	func getLayout() -> NewSnapLayout {
		return snapLayout
	}
	
	func getOrigin() -> (Int, Int) {
		return bottomLeft
	}
	
	func getDimensions() -> (Int, Int) {
		return dimensions
	}
	
	func getTopRight() -> (Int, Int) {
		return topRight
	}
	
	func getWidthFraction(dividend: Int) -> Int {
		return (bottomLeft.0 + topRight.0)/dividend
	}
	
	func getHeightFraction(dividend: Int) -> Int {
		return (bottomLeft.1 + topRight.1)/dividend
	}
	
	func withinBounds(x_coord: Int, y_coord: Int) -> Bool {
		if x_coord < bottomLeft.0 || x_coord > topRight.0 {
			return false
		}
		if y_coord < bottomLeft.1 || y_coord > topRight.1 {
			return false
		}
		return true
	}
 }
