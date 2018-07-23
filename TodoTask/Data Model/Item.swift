//
//  Item.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/22/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
