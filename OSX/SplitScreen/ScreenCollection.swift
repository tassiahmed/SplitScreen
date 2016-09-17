//
//  ScreenCollection.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 9/10/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class ScreenCollection {
	
	fileprivate var screens: [Screen]
	
	init() {
		screens = []
		for screen in NSScreen.screens()! {
			let new_screen = Screen.init(screen: screen)
			screens.append(new_screen)
		}
	}
	
	func size() -> (Int) {
		return screens.count
	}
	
	func get(_ index: Int) -> Screen {
		return screens[index]
	}
	
	func setLayoutforScreen(_ index: Int, layout: SnapLayout) {
		screens[index].setSnapLayout(layout)
	}
	
	func reload() {
		screens.removeAll()
		for screen in NSScreen.screens()! {
			let new_screen = Screen.init(screen: screen)
			screens.append(new_screen)
		}
	}
	
	func getMainScreen() -> Screen {
		return screens[0]
	}
	
	func getCurrentScreen(_ x_coord: Int, y_coord: Int) -> Screen {
		var current_screen: Screen = Screen()
		for screen in screens {
			if x_coord < screen.getOrigin().0 || x_coord > screen.getTopRight().0 {
				continue
			}
			if y_coord < screen.getOrigin().1 || y_coord > screen.getTopRight().1 {
				continue
			}
			current_screen = screen
		}
		return current_screen
	}
	
	func printScreens() {
		for screen in screens {
			print("Origin:", screen.getOrigin(), "Dimensions:", screen.getDimensions(),
			      "Top-Right:", screen.getTopRight())
		}
	}
}
