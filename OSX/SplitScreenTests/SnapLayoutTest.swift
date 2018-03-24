//
//  SnapLayoutTest.swift
//  SplitScreenTests
//
//  Created by Tausif Ahmed on 3/24/18.
//  Copyright © 2018 SplitScreen. All rights reserved.
//

import XCTest

@testable import SplitScreen

class SnapLayoutTest: XCTestCase {
  var testLayout: SnapLayout!
  var snapArea: SnapArea!
  override func setUp() {
      super.setUp()
      testLayout = SnapLayout()
      testLayout.loadLayout(templateName: "standard")

      let area: ((Int, Int), (Int, Int)) = ((-100, -100), (0, 0))
      let screenDimensions: (Int, Int) = (1280, 800)
      let snapDimensions: (Int, Int) = (800, 600)
      let snapLocation: (Int, Int) = (0, 100)
      snapArea = SnapArea(
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

  func testIsHardPoint() {
    XCTAssertTrue(testLayout.isHardPoint(x: 0, y: 0))
    XCTAssertTrue(testLayout.isHardPoint(x: 1280, y: 800))
    XCTAssertTrue(testLayout.isHardPoint(x: 0, y: 400))
    XCTAssertTrue(testLayout.isHardPoint(x: 640, y: 800))
    testLayout.clearLayout()
    XCTAssertFalse(testLayout.isHardPoint(x: 0, y: 0))
  }

  func testAddArea() {
    XCTAssertFalse(testLayout.isHardPoint(x: -100, y: -100))
		testLayout.addArea(area: snapArea)
    XCTAssertTrue(testLayout.isHardPoint(x: -100, y: -100))
  }

  func testGetSnapWindow() {
    let originSnapWindow: ((Int, Int), (Int, Int)) = ((0, 0), (640, 400))
    XCTAssertEqual(originSnapWindow.0.0, testLayout.getSnapWindow(x: 0, y: 0).0.0)
		XCTAssertEqual(originSnapWindow.0.1, testLayout.getSnapWindow(x: 0, y: 0).0.1)
		XCTAssertEqual(originSnapWindow.1.0, testLayout.getSnapWindow(x: 0, y: 0).1.0)
		XCTAssertEqual(originSnapWindow.1.1, testLayout.getSnapWindow(x: 0, y: 0).1.1)

		XCTAssertEqual(-1, testLayout.getSnapWindow(x: -1, y: -1).0.0)
		XCTAssertEqual(-1, testLayout.getSnapWindow(x: -1, y: -1).0.1)
		XCTAssertEqual(-1, testLayout.getSnapWindow(x: -1, y: -1).1.0)
		XCTAssertEqual(-1, testLayout.getSnapWindow(x: -1, y: -1).1.1)
  }

  func testToString() {
    testLayout.clearLayout()
		testLayout.addArea(area: snapArea)
    var actualString: String = testLayout.toString()
    let areaString = snapArea.toString()

    XCTAssertEqual(areaString, actualString)

		testLayout.addArea(area: snapArea)
		actualString = testLayout.toString()
		XCTAssertEqual(areaString + areaString, actualString)
  }
}
