//
//  TreeItem.swift
//  TestApp
//
//  Created by Oleg Sherbakov on 10/07/2018.
//  Copyright © 2018 some org. All rights reserved.
//

import Foundation

class TreeItem
{
    public var title: String
    public var id: Int? = nil
    public var subs: [TreeItem]? = nil
    
    init(withTitle title: String, id: Int? = nil)
    {
        self.title = title
        self.id = id
    }
    
    
}
