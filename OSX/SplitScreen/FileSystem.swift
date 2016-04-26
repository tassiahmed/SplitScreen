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
	
	private var bundleID: NSString
	private var fileManager: NSFileManager
	private var dirPath: NSURL
	private var files: [File]
	
	init() {
		bundleID = NSBundle.mainBundle().bundleIdentifier!
		fileManager = NSFileManager.defaultManager()
		
		let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
		dirPath = appDelegate.applicationDocumentsDirectory
		files = [File]()
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
	
	func readBasicTemplates() {
		for file in files {
			var text: String = String()
			do {
				try text = String(contentsOfFile: file.getPathString(), encoding: NSUTF8StringEncoding)
			} catch _ {
				print("Could not read from \(file.getFileName())")
			}
			print(text)
		}
//		let file = File(dirPath: dirPath, name: "test.lao")
	}
	
	func saveLayout(layout: SnapLayout, name: String) {
		let file = File(dirPath: dirPath, name: name)
		file.parseSnapLayoutToString(layout)
		
	}
	
}