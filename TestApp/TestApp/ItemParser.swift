//
//  JsonItemParser.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation
import SwiftyJSON



class ItemParser
{
    enum JsonKey: String
    {
        case title = "title"
        case id = "id"
        case subs = "subs"
    }
    class func parseJsonFrom(string: String) -> [TreeItem]
    {
        let json = JSON(parseJSON: string)
        return json.arrayValue.map({parse(item: $0)})
    }
    
    private class func parse(item itemJson:JSON) -> TreeItem
    {
        guard let title = itemJson[JsonKey.title.rawValue].string else
        {
            return TreeItem(withTitle: "")
        }
        
        let id = itemJson[JsonKey.id.rawValue].int
        let subs = itemJson[JsonKey.subs.rawValue].array
        
        let item = TreeItem(withTitle: title, id: id)
        item.subs = subs?.map({parse(item: $0)})
    
        return item
    }
}
