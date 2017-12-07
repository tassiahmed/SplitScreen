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
	
	fileprivate var screens = [Screen]()
	
	init() {
		screens = []
		for screen in NSScreen.screens {
			let newScreen = Screen.init(screen: screen)
			screens.append(newScreen)
		}
	}
	
	func size() -> (Int) {
		return screens.count
	}
	
	func get(_ index: Int) -> Screen {
		return screens[index]
	}
	
	func setLayoutforScreen(index: Int, layout: NewSnapLayout) {
		screens[index].setSnapLayout(layout: layout)
	}
	
	func reload() {
		screens.removeAll()
		for screen in NSScreen.screens {
			let newScreen = Screen.init(screen: screen)
			screens.append(newScreen)
		}
	}
	
	func getMainScreen() -> Screen {
		return screens[0]
	}
	
	func getCurrentScreen(x_coord: Int, y_coord: Int) -> Screen {
		var currentScreen: Screen = Screen()
		for screen in screens {
			if x_coord < screen.getOrigin().0 || x_coord > screen.getTopRight().0 {
				continue
			}
			if y_coord < screen.getOrigin().1 || y_coord > screen.getTopRight().1 {
				continue
			}
			currentScreen = screen
			break
		}
		return currentScreen
	}
	
	func printScreens() {
		for screen in screens {
			print("Origin:", screen.getOrigin(), "Dimensions:", screen.getDimensions(),
			      "Top-Right:", screen.getTopRight())
		}
	}
}
