//
//  ItemManager.swift
//  ToDo
//
//  Created by Roman Subrichak on 9/9/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import Foundation
import UIKit

class ItemManager: NSObject {
	
	var toDoCount: Int {
		return toDoItems.count
	}
	var doneCount: Int {
		return doneItems.count
	}
	
	private var toDoItems = [ToDoItem]()
	private var doneItems = [ToDoItem]()
	
	override init() {
		super.init()
		
	NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
		
		if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
			for dict in nsToDoItems {
				if let toDoItem = ToDoItem(dict: dict as! [String: Any]) {
					toDoItems.append(toDoItem)
				}
			}
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
		save()
	}
	
	var toDoPathURL: URL {
		let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		
		guard let documentURL = fileURLs.first else {
			fatalError()
		}
		
		return documentURL.appendingPathComponent("toDoItems.plist")
	}
	
	@objc func save() {
		let nsToDoItems = toDoItems.map { $0.plistDict }
		
		guard nsToDoItems.count > 0 else {
			try? FileManager.default.removeItem(at: toDoPathURL)
			return
		}
		
		do {
			let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems, format: .xml, options: PropertyListSerialization.WriteOptions(0))
			try plistData.write(to: toDoPathURL)
		} catch {
			print(error)
		}
	}
	
	func add(_ item: ToDoItem) {
		if !toDoItems.contains(item) {
			toDoItems.append(item)
		}
	}
	
	func item(at index: Int) -> ToDoItem {
		return toDoItems[index]
	}
	
	func checkItem(at index: Int) {
		let item = toDoItems.remove(at: index)
		doneItems.append(item)
	}
	
	func uncheckItem(at index: Int) {
		let item = doneItems.remove(at: index)
		toDoItems.append(item)
	}
	
	func doneItem(at index: Int) -> ToDoItem {
		return doneItems[index]
	}
	
	func removeAll() {
		toDoItems.removeAll()
		doneItems.removeAll()
	}
}
