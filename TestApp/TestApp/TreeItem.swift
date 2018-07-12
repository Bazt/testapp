//
//  TreeItem.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation

@objc class TreeItem : NSObject, NSCopying, NSCoding
{
    enum Key: String
    {
        case title = "title"
        case id = "id"
        case subs = "subs"
    }
    
    func copy(with zone: NSZone? = nil) -> Any
    {
        let result = TreeItem(withTitle: self.title, id: self.id)
        result.subs = self.subs?.map({ $0.copy() }) as? [TreeItem]
        return result
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.title, forKey: Key.title.rawValue)
        aCoder.encode(self.id, forKey: Key.id.rawValue)
        aCoder.encode(self.subs, forKey: Key.subs.rawValue)
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.title = aDecoder.decodeObject(forKey: Key.title.rawValue) as! String
        self.id = aDecoder.decodeObject(forKey: Key.id.rawValue) as? Int
        self.subs = aDecoder.decodeObject(forKey: Key.subs.rawValue) as? [TreeItem]
    }

    override var hashValue: Int
    {
        return title.hashValue
    }
    
    static func == (lhs: TreeItem, rhs: TreeItem) -> Bool
    {
        return lhs.title == rhs.title
    }
    
    public var title: String
    public var id: Int? = nil
    public var subs: [TreeItem]? = nil
    
    init(withTitle title: String, id: Int? = nil)
    {
        self.title = title
        self.id = id
    }
    
    
}
