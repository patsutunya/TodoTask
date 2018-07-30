//
//  Category.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/29/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
