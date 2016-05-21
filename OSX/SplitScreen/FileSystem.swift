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
	
	private var fileManager: NSFileManager
	private var dirPath: NSURL
	private var files: [File]
	private let pathExtension = ".lao"
	let HEIGHT = Int((NSScreen.mainScreen()?.frame.height)!)
	let WIDTH = Int((NSScreen.mainScreen()?.frame.width)!)
	
	init() {
		fileManager = NSFileManager.defaultManager()
		
		let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
		dirPath = appDelegate.applicationDocumentsDirectory
		files = [File]()
		self.getAllLayoutFiles()
	}
	
	
	func createBasicTemplates() {
		let file = File(dirPath: dirPath, name: "test.lao")
		let test_text = "TESTING FILE CREATION"
		
		do {
			try test_text.writeToFile(file.getPathString(), atomically: false, encoding: NSUTF8StringEncoding)
		} catch _ {
			print("Could not write to \(file.getFileName())")
		}
		files.append(file)
	}
	
	func readLayouts() {
		for file in files {
			print(file.parseFileContent(HEIGHT, width: WIDTH))
			print("******************")
		}
	}
	
	func loadLayout(file_name: String) {
		let file = File(dirPath: dirPath, name: file_name.stringByAppendingString(pathExtension))
		if files.indexOf(file) == nil {
			return
		}
		let snap_points = file.parseFileContent(HEIGHT, width: WIDTH)
		layout.snap_points.removeAll()
		for snap_point in snap_points {
			let snap: SnapPoint = SnapPoint.init(height: snap_point[0], width: snap_point[1], x_dim: snap_point[2], y_dim: snap_point[3], x_snap_loc: snap_point[4], y_snap_loc: snap_point[5], log: snap_point[6])
			snap.add_snap_point(snap_point[7], y0: snap_point[8], x1: snap_point[9], y1: snap_point[10])
			layout.snap_points.append(snap)
		}
	}
	
	func saveLayout(layout: SnapLayout, name: String) {
		let file = File(dirPath: dirPath, name: name.stringByAppendingString(pathExtension))
		let content = layout.toString()

		do {
			try content.writeToFile(file.getPathString(), atomically: false, encoding: NSUTF8StringEncoding)
		} catch _ {
			print("Could not write to \(file.getFileName()))")
		}
		if files.indexOf(file) == nil {
			files.append(file)
		}
	}
	
	func getAllLayoutFiles() {
		if let enumerator = fileManager.enumeratorAtPath(dirPath.path!) {
			while let file = enumerator.nextObject() {
				let file_name = file as! String
				if file_name.hasSuffix(".lao") {
					files.append( File(dirPath: dirPath, name: file_name) )
				}
			}
		}
	}
	
}