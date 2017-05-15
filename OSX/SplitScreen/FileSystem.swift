//
//  FileSystem.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 4/5/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class FileSystem {
	
	fileprivate var fileManager: FileManager
	fileprivate var dirPath: URL
	fileprivate var files: [File]
	fileprivate let pathExtension = ".lao"
	let HEIGHT = Int((NSScreen.main()?.frame.height)!)
	let WIDTH = Int((NSScreen.main()?.frame.width)!)
	
	/**
		Inits `FileSystem` with default `NSFileManager`, retrieves current directory path, and
		retrieves all currently existing `SnapLayout` files that exist in the directory
	*/
	init() {
		fileManager = FileManager.default
		
		let appDelegate = NSApplication.shared().delegate as! AppDelegate
		dirPath = appDelegate.applicationDocumentsDirectory as URL
		files = [File]()
		self.getAllLayoutFiles()
	}
	
	/**
		Checks to see if the the basic `SnapLayout` files are in the document directory and
		if not, then they are created and added to the directory
	*/
	func createBasicLayouts() {
		var file = File(dirPath: dirPath, name: "Standard.lao")
		if files.index(of: file) == nil {
			layout.load("standard")
			let content: String = layout.toString()
			
			do {
				try content.write(toFile: file.getPathString(), atomically: false, encoding: String.Encoding.utf8)
			} catch _ {
				print("Could not write to \(file.getFileName()))")
			}
			
			files.append(file)
		}
		
		file = File(dirPath: dirPath, name: "Horizontal.lao")
		if files.index(of: file) == nil {
			layout.load("horizontal")
			let content: String = layout.toString()
			
			do {
				try content.write(toFile: file.getPathString(), atomically: false, encoding: String.Encoding.utf8)
			} catch _ {
				print("Could not write to \(file.getFileName()))")
			}
			
			files.append(file)
		}
	}
	
	/**
		Reads out all the layouts that are currently in the `FileSystem`
	*/
	func readLayouts() {
		for file in files {
			print(file.parseFileContent(screens.getMainScreen()))
			print("******************")
		}
	}
	
	
	/**
		Load the `SnapLayout` file with the same name as `file_name`
	
		- Parameter file_name: `String` that corresponds to the speciic name of a `SnapLayout` fle
	*/
	func loadLayout(_ file_name: String) {
		let file = File(dirPath: dirPath, name: file_name + pathExtension)
		if files.index(of: file) == nil {
			return
		}
		
		for i in 0 ..< screens.size() {
			let snap_points = file.parseFileContent(screens.get(i))
			let temp_layout: SnapLayout = SnapLayout()
			for snap_point in snap_points {
				let snap: SnapPoint = SnapPoint.init(screen_dim: (current_screen.getDimensions().0,
				                                                  current_screen.getDimensions().1),
				                                     snap_dim: (snap_point[0], snap_point[1]),
				                                     snap_loc: (snap_point[2], snap_point[3]))
				snap.add_snap_point(first: (snap_point[4], snap_point[5]),
				                    second: (snap_point[6], snap_point[7]))
				temp_layout.snap_points.append(snap)
			}
			screens.setLayoutforScreen(i, layout: temp_layout)
		}
		
		layout = screens.getMainScreen().getLayout()
	}
	
	/**
		Saves the settings of the current layout to new `File` with the name `name`
	
		- Parameter name: `String` that corresponds to the new name of the `File`
	*/
	func saveLayout(_ name: String) {
		let file = File(dirPath: dirPath, name: name + pathExtension)
		let content = layout.toString()

		do {
			try content.write(toFile: file.getPathString(), atomically: false, encoding: String.Encoding.utf8)
		} catch _ {
			print("Could not write to \(file.getFileName()))")
		}
		if files.index(of: file) == nil {
			files.append(file)
		}
	}
	
	/**
		Get all the files that are located in the current documents directory
	*/
	func getAllLayoutFiles() {
		if let enumerator = fileManager.enumerator(atPath: dirPath.path) {
			while let file = enumerator.nextObject() {
				let file_name = file as! String
				if file_name.hasSuffix(".lao") {
					files.append( File(dirPath: dirPath, name: file_name) )
				}
			}
		}
	}
	
}
