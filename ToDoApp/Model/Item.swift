//
//  Item.swift
//  ToDoApp
//
//  Created by Alperen Ünal on 6.11.2018.
//  Copyright © 2018 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
   var upperCategory = LinkingObjects(fromType: Category.self, property: "items")
}
