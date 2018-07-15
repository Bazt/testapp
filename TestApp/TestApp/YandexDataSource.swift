//
//  YandexDataSource.swift
//  TestApp
//
//  Created by Oleg Shcherbakov on 14/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation
class YandexDataSource
{
    static let shared = YandexDataSource()
    var allItems = [TreeItem]()
    private(set) var currentItems = [TreeItem]()
    
    
    func itemSelectedAt(index: Int)
    {
        if let count = currentItems[index].subs?.count, count > 0
        {
            set(currentItems: currentItems[index].subs!)
        }
    }
    
    func set(currentItems items: [TreeItem])
    {
        history.append(items)
        currentItems = items
    }
    
    func goBack()
    {
        _ = history.popLast()
        currentItems = history.last ?? []
    }
    
    private var history = [[TreeItem]]()
    
    private init(withAllItems items: [TreeItem] = [], andCurrenItems currentItems: [TreeItem] = [])
    {
        self.allItems = TestAppDatabase.getItems() ?? items
        self.currentItems = self.allItems
        self.history = [self.allItems]
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name.DataChanged, object: nil, queue: nil)
        {
            (_) in
            DispatchQueue.main.sync
            {
                guard let xs = TestAppDatabase.getItems() else
                {
                    return
                }
                self.allItems = xs
                self.currentItems = xs
                self.history = [self.allItems]
            }
            
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
}
