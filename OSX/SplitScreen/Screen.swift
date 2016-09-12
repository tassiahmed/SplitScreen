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
	
	private var snapLayout: SnapLayout
	private var bottomLeft, dimensions: (Int, Int)
	
	init(screen: NSScreen) {
		snapLayout = layout
		bottomLeft = (Int(screen.frame.origin.x), Int(screen.frame.origin.y))
		dimensions = (Int(screen.frame.size.width), Int(screen.frame.size.height))
	}
	
	func getOrigin() -> (Int, Int) {
		return bottomLeft
	}
	
	func getDimensions() -> (Int, Int) {
		return dimensions
	}
	
}
