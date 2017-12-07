//
//  GlobalVariables.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 9/10/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation

//File System
var fileSystem: FileSystem = FileSystem.init()

// Layout currently being used
var layout: SnapLayout = SnapLayout()

// Display the position of potential window snap
var snapHighlighter: SnapHighlighter = SnapHighlighter()

// Mouse position
var lastKnownMouseDrag: CGPoint?