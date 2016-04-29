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
			var text: String = String()
			do {
				try text = String(contentsOfFile: file.getPathString(), encoding: NSUTF8StringEncoding)
			} catch _ {
				print("Could not read from \(file.getFileName())")
			}
			print(file.getFileName())
			print(text)
		}
	}
	
	func saveLayout(layout: SnapLayout, name: String) {
		let file = File(dirPath: dirPath, name: name.stringByAppendingString(pathExtension))
		let content = self.parseSnapLayoutToString(layout)

		do {
			try content.writeToFile(file.getPathString(), atomically: false, encoding: NSUTF8StringEncoding)
		} catch _ {
			print("Could not write to \(file.getFileName()))")
		}
		if files.indexOf(file) == nil {
			files.append(file)
		}
	}
	
	func parseSnapLayoutToString(layout: SnapLayout) -> String {
		var retString: String = String()
		for snap_point in layout.snap_points {
			retString = retString.stringByAppendingString(snap_point.get_string_representation())
		}
		return retString
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