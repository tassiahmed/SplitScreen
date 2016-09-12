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
	
	private var screens: [Screen]
	
	init() {
		screens = []
		for screen in NSScreen.screens()! {
			let new_screen = Screen.init(screen: screen)
			screens.append(new_screen)
		}
	}
	
	func printScreens() {
		for screen in screens {
			print(screen.getOrigin())
			print(screen.getDimensions())
		}
	}
	
}