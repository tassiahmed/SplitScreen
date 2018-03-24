//
//  SnapAreaTest.swift
//  SplitScreenTests
//
//  Created by Tausif Ahmed on 2/3/18.
//  Copyright © 2018 SplitScreen. All rights reserved.
//

import XCTest

@testable import SplitScreen

class SnapAreaTest: XCTestCase {
	var testArea: SnapArea!

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		let area: ((Int, Int), (Int, Int)) = ((200, 200), (400, 400))
		let screenDimensions: (Int, Int) = (1280, 800)
		let snapDimensions: (Int, Int) = (800, 600)
		let snapLocation: (Int, Int) = (0, 100)
		testArea = SnapArea(
      area: area,
      screenDimensions: screenDimensions,
      snapDimensions: snapDimensions,
      snapLocation: snapLocation
    )
	}

	override func tearDown() {
			// Put teardown code here. This method is called after the invocation of each test method in the class.
			super.tearDown()
	}

	func testInSnapArea() {
		XCTAssertTrue(testArea.inSnapArea(x: 300, y: 300))
		XCTAssertTrue(testArea.inSnapArea(x: 200, y: 200))
		XCTAssertTrue(testArea.inSnapArea(x: 400, y: 400))
		XCTAssertTrue(testArea.inSnapArea(x: 300, y: 400))
		XCTAssertTrue(testArea.inSnapArea(x: 200, y: 300))
		XCTAssertFalse(testArea.inSnapArea(x: 0, y: 0))
		XCTAssertFalse(testArea.inSnapArea(x: 200, y: 500))
		XCTAssertFalse(testArea.inSnapArea(x: 100, y: 400))
		XCTAssertFalse(testArea.inSnapArea(x: 500, y: 500))
	}

	func testGetSnapLocation() {
		XCTAssertEqual(0, testArea.getSnapLocation().0)
		XCTAssertEqual(100, testArea.getSnapLocation().1)
	}

  func testGetSnapDimensions() {
    XCTAssertEqual(800, testArea.getSnapDimensions().0)
    XCTAssertEqual(600, testArea.getSnapDimensions().1)
  }

  func testGetScreenDimensions() {
    XCTAssertEqual(1280, testArea.getScreenDimensions().0)
    XCTAssertEqual(800, testArea.getScreenDimensions().1)
  }

  func testToString() {
    let actualString = testArea.toString()
		let expectedString = "WIDTH/1,HEIGHT/1,0,HEIGHT/8,(WIDTH/6;HEIGHT/4):(WIDTH/3;HEIGHT/2)\n"
		XCTAssertEqual(expectedString, actualString)
  }
}
