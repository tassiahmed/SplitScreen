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
	
	func parseFileContent(height: Int, width: Int) -> [[Int]] {
		var text: String = String()
		var snap_params: [[Int]] = []
		do {
			try text = String(contentsOfFile: path.path!, encoding: NSUTF8StringEncoding)
		} catch _ {
			print("Could not read from \(file_name)")
		}
//		print(file_name)
		let lines = text.characters.split("\n").map(String.init)
		for line in lines {
//			print(line)
			let components = line.characters.split(",").map(String.init)
			var snap_param: [Int] = []
			for component in components {
				
				if component == "HEIGHT" {
					snap_param.append(height)
				} else if component == "WIDTH" {
					snap_param.append(width)
				} else if component == "0" {
					snap_param.append(0)
				} else if component != components.last {
					if component.rangeOfString("/") != nil {
						let dividends = component.characters.split("/").map(String.init)
						if dividends[0] == "HEIGHT" {
							snap_param.append(height/Int(dividends[1])!)
						} else {
							snap_param.append(width/Int(dividends[1])!)
						}
					} else if component.rangeOfString("-") != nil {
						let dividends = component.characters.split("-").map(String.init)
						if dividends[0] == "HEIGHT" {
							snap_param.append(height - Int(dividends[1])!)
						} else {
							snap_param.append(width - Int(dividends[1])!)
						}
					}
					
				} else {
					let snap_points = component.characters.split(":").map(String.init)
					for snap_point in snap_points {
						var xCoord: Int
						var yCoord: Int
						var tuple: String = snap_point
						tuple.removeAtIndex(tuple.startIndex)
						tuple.removeAtIndex(tuple.endIndex.predecessor())
//						print(tuple)
						let coords = tuple.characters.split(";").map(String.init)
						if coords[0] == "0" {
							xCoord = 0
						} else if coords[0].rangeOfString("-") != nil {
							let dividends = coords[0].characters.split("-").map(String.init)
							xCoord = width - Int(dividends[1])!
						} else if coords[0].rangeOfString("/") != nil {
							let dividends = coords[0].characters.split("/").map(String.init)
							xCoord = width/Int(dividends[1])!
						} else {
							xCoord = width
						}
						
						if coords[1] == "0" {
							yCoord = 0
						} else if coords[1].rangeOfString("-") != nil {
							let dividends = coords[1].characters.split("-").map(String.init)
							yCoord = height - Int(dividends[1])!
						} else if coords[1].rangeOfString("/") != nil {
							let dividends = coords[1].characters.split("/").map(String.init)
							yCoord = height/Int(dividends[1])!
						} else {
							yCoord = height
						}
						
						snap_param.append(xCoord)
						snap_param.append(yCoord)
					}
				}
			}
			snap_params.append(snap_param)
		}
		return snap_params
	}
}

func ==(lhs: File, rhs: File) -> Bool {
	return lhs.getPathString() == rhs.getPathString() && lhs.getFileName() == rhs.getFileName()
}