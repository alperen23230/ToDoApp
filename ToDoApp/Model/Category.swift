//
//  Category.swift
//  ToDoApp
//
//  Created by Alperen Ünal on 6.11.2018.
//  Copyright © 2018 Alperen Ünal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
