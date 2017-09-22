//
//  StoryboardTests.swift
//  ToDoTests
//
//  Created by Roman Subrichak on 9/17/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import XCTest
@testable import ToDo
import UIKit

class StoryboardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
	func test_InitialViewController_IsItemListViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		let navigationCotroller = storyboard.instantiateInitialViewController() as! UINavigationController
		let rootViewController = navigationCotroller.viewControllers[0]
		XCTAssertTrue(rootViewController is ItemListViewController)
	}
}
