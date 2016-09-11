//
//  GlobalVariables.swift
//  SplitScreen
//
//  Created by Tausif Ahmed on 9/10/16.
//  Copyright © 2016 SplitScreen. All rights reserved.
//

import Foundation

//File System
var file_system: FileSystem = FileSystem.init()

// Layout currently being used
var layout: SnapLayout = SnapLayout()

// Display the position of potential window snap
var snap_highlighter: SnapHighlighter = SnapHighlighter()

// Mouse position
var last_known_mouse_drag: CGPoint?