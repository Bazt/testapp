//
//  YandexDataSource.swift
//  TestApp
//
//  Created by Oleg Shcherbakov on 14/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation
import UIKit

class YandexDataSource: NSObject, UITableViewDataSource {
    static let shared = YandexDataSource()

    var allItems = [TreeItem]()
    private(set) var currentItems = [TreeItem]()
    private var history = [[TreeItem]]()

    func itemSelectedAt(index: Int) {
        if let count = currentItems[index].subs?.count, count > 0 {
            set(currentItems: currentItems[index].subs!)
        }
    }

    func set(currentItems items: [TreeItem]) {
        history.append(items)
        currentItems = items
    }

    func goBack() {
        _ = history.popLast()
        currentItems = history.last ?? []
    }

    func updateFromDB() {
        self.allItems = TestAppDatabase.getItems()
        self.currentItems = self.allItems
        history = [self.currentItems]
    }

    private override init() {
        super.init()

        updateFromDB()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection = \(currentItems.count)")
        return currentItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestAppViewController.reuseIdentifier, for: indexPath) as UITableViewCell
        let itemsToShow = YandexDataSource.shared.currentItems
        cell.textLabel?.text = itemsToShow[indexPath.row].title
        if let count = itemsToShow[indexPath.row].subs?.count, count > 0 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
            cell.isUserInteractionEnabled = false
        }
        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
        
    }

}
