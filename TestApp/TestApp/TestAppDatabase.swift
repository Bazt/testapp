//
//  TestAppDatabase.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 12/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation
import YapDatabase

class TestAppDatabase
{
    struct Collections
    {
        static let YandexJson = "YandexJson"
    }
    
    private static var dbPath: String
    {
        var documentsUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        documentsUrl.appendPathComponent("TestAppData")
        documentsUrl.appendPathComponent(".db")
        try! FileManager.default.createDirectory(at: documentsUrl, withIntermediateDirectories: true)
        documentsUrl.appendPathComponent("test_app_db.yapdb")
        return documentsUrl.absoluteString
    }
    
    private static var db: YapDatabase =
    {
        return YapDatabase(path: dbPath)!
    }()
    
    private static var sharedConnection: YapDatabaseConnection
    {
        return db.newConnection()
    }
    
    class func save(items: [TreeItem])
    {
        sharedConnection.asyncReadWrite
        {
            (transaction) in
            transaction.setObject(items, forKey: Collections.YandexJson, inCollection: Collections.YandexJson)
            NotificationQueue.default.enqueue(Notification(name: .DataChanged), postingStyle: .whenIdle)
        }
    }
    
    class func getItems() -> [TreeItem]?
    {
        var result: [TreeItem]? = nil
        sharedConnection.read
        {
                (transaction) in
            result = transaction.object(forKey: Collections.YandexJson, inCollection: Collections.YandexJson) as? [TreeItem]
        }
        return result
    }
}

extension Notification.Name
{
    static let DataChanged = Notification.Name(rawValue: "DataChanged")
}
