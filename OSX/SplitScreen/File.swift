//
//  File.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 4/26/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class File {
	
	private var path: NSURL
	private var file_name: String
	let HEIGHT = Int((NSScreen.mainScreen()?.frame.height)!)
	let WIDTH = Int((NSScreen.mainScreen()?.frame.width)!)
	
	init(dirPath: NSURL, name: String) {
		file_name = name
		path = dirPath.URLByAppendingPathExtension(name)
	}
	
	func getFileName() -> String {
		return file_name
	}
	
	func getPathString() -> String {
		return path.path!
	}
	
//	func parseSnapLayoutToString(layout: SnapLayout) -> String {
//		var ret_string: String = String()
//		for snap_point in layout.snap_points {
//			
//		}
//		return ret_string
//	}
	
}