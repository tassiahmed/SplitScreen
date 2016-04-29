//
//  File.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 4/26/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class File: Equatable {
	
	private var path: NSURL
	private var file_name: String
	let HEIGHT = Int((NSScreen.mainScreen()?.frame.height)!)
	let WIDTH = Int((NSScreen.mainScreen()?.frame.width)!)
	
	init(dirPath: NSURL, name: String) {
		file_name = name
		path = dirPath.URLByAppendingPathComponent(name)
//		path = NSURL(string: (dirPath.path)!.stringByAppendingString("/\(name)"))!
//		path = dirPath.URLByAppendingPathExtension(name)
	}
	
	func getFileName() -> String {
		return file_name
	}
	
	func getPathString() -> String {
		return path.path!
	}
}

func ==(lhs: File, rhs: File) -> Bool {
	return lhs.getPathString() == rhs.getPathString() && lhs.getFileName() == rhs.getFileName()
}