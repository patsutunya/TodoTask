//
//  Item.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/29/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
