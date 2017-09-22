//
//  ItemManagerTest.swift
//  ToDoTests
//
//  Created by Roman Subrichak on 9/9/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTest: XCTestCase {
	
	var sut: ItemManager!
    
    override func setUp() {
        super.setUp()
		sut = ItemManager()
    }
    
    override func tearDown() {
       sut.removeAll()
		sut = nil
        super.tearDown()
    }
    
	func test_ToDoCount_Initially_IsZero() {
		XCTAssertEqual(sut.toDoCount, 0)
	}
	
	func test_DoneCount_Initially_IsZero() {
		XCTAssertEqual(sut.doneCount, 0)
	}
	
	func test_AddItem_IncreasesToDoCountToOne() {
		sut.add(ToDoItem(title: ""))
		
		XCTAssertEqual(sut.toDoCount, 1)
	}
	
	func test_ItemAt_AfterAddingItem_ReturnsThatItem() {
		let item = ToDoItem(title: "Foo")
		sut.add(item)
		
		let returnItem = sut.item(at: 0)
		
		XCTAssertEqual(returnItem.title, item.title)
	}
	
	func test_CheckItemAt_ChangesCounts() {
		sut.add(ToDoItem(title: ""))
		sut.checkItem(at: 0)
		
		XCTAssertEqual(sut.toDoCount, 0)
		XCTAssertEqual(sut.doneCount, 1)
	}
	
	func test_CheckItemAt_RemovesItFromToDoItems() {
		let first = ToDoItem(title: "First")
		let second = ToDoItem(title: "Second")
		
		sut.add(first)
		sut.add(second)
		
		sut.checkItem(at: 0)
		
		XCTAssertEqual(sut.item(at: 0).title, "Second")
	}
	
	func test_DoneItemAt_ReturnsCheckedItem() {
		let item = ToDoItem(title: "Foo")
		sut.add(item)
		
		sut.checkItem(at: 0)
		let returnItem = sut.doneItem(at: 0)
		
		XCTAssertEqual(returnItem.title, item.title)
	}
	
	func test_RemoveAll_ResultsInCountsBeZero() {
		sut.add(ToDoItem(title: "Foo"))
		sut.add(ToDoItem(title: "Bar"))
		sut.checkItem(at: 0)
		
		XCTAssertEqual(sut.toDoCount, 1)
		XCTAssertEqual(sut.doneCount, 1)
		
		sut.removeAll()
		
		XCTAssertEqual(sut.toDoCount, 0)
		XCTAssertEqual(sut.doneCount, 0)
	}
	
	func test_Add_WhenItemIsAlreadyAdded_DoesNotIncreaseCount() {
		sut.add(ToDoItem(title:"Foo"))
		sut.add(ToDoItem(title: "Foo"))
		
		XCTAssertEqual(sut.toDoCount, 1)
	}
	func test_ToDoItemsGetSerialized() {
		var itemManager: ItemManager? = ItemManager()
		
		let first = ToDoItem(title: "First")
		itemManager!.add(first)
		
		let second = ToDoItem(title: "Second")
		itemManager!.add(second)
		
		NotificationCenter.default.post(name: .UIApplicationWillResignActive, object: nil)
		
		itemManager = nil
		
		XCTAssertNil(itemManager)
		
		itemManager = ItemManager()
		
		XCTAssertEqual(itemManager?.toDoCount, 2)
		XCTAssertEqual(itemManager?.item(at: 0), first)
		XCTAssertEqual(itemManager?.item(at: 1), second)
	}
}
