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
	
	fileprivate var path: URL
	fileprivate var file_name: String
	
	/**
		Inits the `File` with the `dirPath` and	`name`
	
		- Parameter dirPath: `NSURL` that is where the file will be located
	
		- Parameter name: `String` that to the name of the `File`
	*/
	init(dirPath: URL, name: String) {
		file_name = name
		path = dirPath.appendingPathComponent(name)
	}
	
	/**
		Returns `file_name`
	
		- Returns: `String` that is the name of the `File`
	*/
	func getFileName() -> String {
		return file_name
	}
	
	/**
		Returns `path`
	
		- Returns: `String` representation of the `NSURL` for the `File`
	*/
	func getPathString() -> String {
		return path.path
	}
	
	/**
		Parses the contents of a file from a text file to an `array` of `arrays` of `Int` values
	
		- Parameter height: `Int` that corresponds to screen's height
	
		- Parameter width: `Int` that corresponds to screen's width
	
		- Returns: `array` of `arrays` of `Int` that contains values for a `SnapPoint` for each `array`
	*/
	func parseFileContent(_ height: Int, width: Int) -> [[Int]] {
		var text: String = String()
		var snap_params: [[Int]] = []
		
		// Attempt to get text from file
		do {
			try text = String(contentsOfFile: path.path, encoding: String.Encoding.utf8)
		} catch _ {
			print("Could not read from \(file_name)")
		}
		
		// Split the text into lines
		let lines = text.characters.split(separator: "\n").map(String.init)
		for line in lines {
			
			// Split line into the different values of a SnapPoint
			let components = line.characters.split(separator: ",").map(String.init)
			var snap_param: [Int] = []
			for component in components {
				
				// General values
				if component == "HEIGHT" {
					snap_param.append(height)
				} else if component == "WIDTH" {
					snap_param.append(width)
				} else if component == "0" {
					snap_param.append(0)
				} else if component != components.last {
					if component.range(of: "/") != nil {
						let dividends = component.characters.split(separator: "/").map(String.init)
						if dividends[0] == "HEIGHT" {
							snap_param.append(height/Int(dividends[1])!)
						} else {
							snap_param.append(width/Int(dividends[1])!)
						}
					} else if component.range(of: "-") != nil {
						let dividends = component.characters.split(separator: "-").map(String.init)
						if dividends[0] == "HEIGHT" {
							snap_param.append(height - Int(dividends[1])!)
						} else {
							snap_param.append(width - Int(dividends[1])!)
						}
					}
					
				// For the snap points that are stored as pairs
				} else {
					let snap_points = component.characters.split(separator: ":").map(String.init)
					for snap_point in snap_points {
						var xCoord: Int
						var yCoord: Int
						var tuple: String = snap_point
						tuple.remove(at: tuple.startIndex)
						tuple.remove(at: tuple.characters.index(before: tuple.endIndex))
						let coords = tuple.characters.split(separator: ";").map(String.init)
						if coords[0] == "0" {
							xCoord = 0
						} else if coords[0].range(of: "-") != nil {
							let dividends = coords[0].characters.split(separator: "-").map(String.init)
							xCoord = width - Int(dividends[1])!
						} else if coords[0].range(of: "/") != nil {
							let dividends = coords[0].characters.split(separator: "/").map(String.init)
							xCoord = width/Int(dividends[1])!
						} else {
							xCoord = width
						}
						
						if coords[1] == "0" {
							yCoord = 0
						} else if coords[1].range(of: "-") != nil {
							let dividends = coords[1].characters.split(separator: "-").map(String.init)
							yCoord = height - Int(dividends[1])!
						} else if coords[1].range(of: "/") != nil {
							let dividends = coords[1].characters.split(separator: "/").map(String.init)
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

/**
	Creates an equality function for files based on their `path` and `file_name`

	- Parameter lhs: `File` that is the left hand `File`

	- Parameter rhs: `File` that is the right hand `File`

	- Returns: `Bool` that teels whether or not the 2 `File` objects are the same
*/
func ==(lhs: File, rhs: File) -> Bool {
	return lhs.getPathString() == rhs.getPathString() && lhs.getFileName() == rhs.getFileName()
}
