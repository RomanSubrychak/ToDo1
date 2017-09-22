//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Roman Subrichak on 9/10/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
	
	var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
	 sut = viewController as! ItemListViewController
		
		_ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func test_TableViewIsNotNilAfterViewDidLoad() {
		
		XCTAssertNotNil(sut.tableView)
	}
	
	func test_LoadingView_SetsTableViewDataSource() {
		XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
	}
	
	func test_LoadingView_SetsTableViewDelegage() {
		XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
	}
	
	func test_LoadingView_SetsDataSourceAndDelegateToTheSameObject() {
		XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
	}
	
	func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
		let target = sut.navigationItem.rightBarButtonItem?.target
		
		XCTAssertEqual(target as? UIViewController, sut)
	}
	
	func test_AddItem_PresentsAddItemViewController() {
		
		setUpInputViewController()
		XCTAssertNotNil(sut.presentedViewController)
		XCTAssertTrue(sut.presentedViewController is InputViewController)
		
		let inputViewController = sut.presentedViewController as! InputViewController
		XCTAssertNotNil(inputViewController.titleTextField)
	}
	
	func test_ItemListVC_SharesItemManagerWithInputVC() {
		
		setUpInputViewController()
		
		guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return }
		guard let itemManager = inputViewController.itemManager else { XCTFail(); return }
		XCTAssertTrue(sut.itemManager === itemManager)
	}
	
	func test_ViewDidLoad_SetsItemManagerToDataProvider() {
		XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
	}
	
	func setUpInputViewController() {
		guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
		guard let action = addButton.action else { XCTFail(); return }
		UIApplication.shared.keyWindow?.rootViewController = sut
		
		sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
	}
	
	func test_AddItem_ReloadsTableView() {
		let mockTableView = MockTableView()
		sut.tableView = mockTableView
		sut.beginAppearanceTransition(true, animated: true)
		sut.endAppearanceTransition()
		XCTAssertTrue(mockTableView.reloadDataGotCalled)
	}
	
	func test_ItemSelectedNotification_PushesDetailViewController() {
		let mockNavigationController = MockNavigationController(rootViewController: sut)
		UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
		sut.itemManager.add(ToDoItem(title: "Foo"))
		
		_ = sut.view
		
		NotificationCenter.default.post(name: Notification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 0])
		
		guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
			XCTFail()
			return
			
		}
		guard let detailItemManager = detailViewController.itemInfo?.0 else {
			XCTFail()
			return
		}
		guard let index = detailViewController.itemInfo?.1 else {
			XCTFail()
			return
		}
		
		_ = detailViewController.view
		XCTAssertNotNil(detailViewController.titleLabel)
		XCTAssertTrue(detailItemManager === sut.itemManager)
		XCTAssertEqual(index, 0)
		
	}
}
extension ItemListViewControllerTests {
	class MockTableView: UITableView {
		var reloadDataGotCalled = false
		
		override func reloadData() {
			super.reloadData()
			reloadDataGotCalled = true
		}
	}
}

extension ItemListViewControllerTests {
	class MockNavigationController: UINavigationController {
		
		var pushedViewController: UIViewController?
		
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			pushedViewController = viewController
			super.pushViewController(viewController, animated: animated)
		}
	}
}
