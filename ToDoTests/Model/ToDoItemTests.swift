//
//  ToDoItemTests.swift
//  ToDoTests
//
//  Created by Roman Subrichak on 9/9/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func test_Init_TakesTitle() {
		_ = ToDoItem(title: "Foo")
	}
	
	func test_Init_TakesTitleAndDescription() {
		_ = ToDoItem(title: "Foo", itemDescription: "Bar")
	}
	
	func test_Init_WhenGivenTitle_SetsTitle() {
		let item = ToDoItem(title: "Foo")
		XCTAssertEqual(item.title, "Foo", "should set title")
	}
	
	func test_Init_WhenGivenItemDescription_setsItemDescription() {
		let item = ToDoItem(title: "", itemDescription: "Bar")
		
		XCTAssertEqual(item.itemDescription, "Bar")
	}
	
	func test_Init_WhenGivenTimestamp_SetsTimestamp() {
		let item = ToDoItem(title: "", timestamp: 0.0)
		XCTAssertEqual(item.timestamp, 0.0, "should setTimeStamp")
	}
	
	func test_Init_WhenGivenLocation_SetsLocation() {
		let location = Location(name: "Foo")
		let todoItem = ToDoItem(title: "", location: location)
		XCTAssertEqual(todoItem.location?.name, "Foo")
	}
	
	func test_EqualItems_AreEqual() {
		let first = ToDoItem(title: "Foo")
		let second = ToDoItem(title: "Foo")
		
		XCTAssertEqual(first, second)
	}
	
	func test_Items_WhenLocationDiffers_AreNotEqual() {
		let first = ToDoItem(title: "", location: Location(name: "Foo"))
		let second = ToDoItem(title: "", location: Location(name: "Bar"))
		
		XCTAssertNotEqual(first, second)
	}
	
	func test_Items_WhenOneLocationIsNilAndOtherIsnt_AreNotEqual() {
		var first = ToDoItem(title: "", location: Location(name: "Foo"))
		var second = ToDoItem(title: "", location: nil)
		
		XCTAssertNotEqual(first, second)
		
		first = ToDoItem(title: "", location: nil)
		second = ToDoItem(title: "", location: Location(name: "Foo"))
		XCTAssertNotEqual(first, second)
	}
	
	func test_Items_WhenTimestampDiffers_AreNotEqual() {
		let first = ToDoItem(title: "", itemDescription: nil, timestamp: 1.0, location: nil)
		let second = ToDoItem(title: "", itemDescription: nil, timestamp: 0.0, location: nil)
		
		XCTAssertNotEqual(first, second)
	}
	
	func test_Items_WhenItemDescriptionsDiffer_AreNotEqual() {
		let first = ToDoItem(title: "Foo", itemDescription: "Bar", timestamp: nil, location: nil)
		let second = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: nil, location: nil)
		XCTAssertNotEqual(first, second)
	}
	
	func test_Items_WhenTitlesDiffer_AreNotEqual() {
		let first = ToDoItem(title: "Foo")
		let second = ToDoItem(title: "Bar")
		
		XCTAssertNotEqual(first, second)
	}
	
	func test_HasPlistDictionaryProperty() {
		let item = ToDoItem(title: "First")
		let dictionary = item.plistDict
		
		XCTAssertNotNil(dictionary)
		XCTAssertTrue(dictionary is [String: Any])
	}
	
	func test_CanBeCreatedFromPlistDictionary() {
		let location = Location(name: "Bar")
		let item = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: 1.0, location: location)
		let dict = item.plistDict
		let recreatedItem = ToDoItem(dict: dict)
		
		XCTAssertEqual(recreatedItem, item)
	}
}
