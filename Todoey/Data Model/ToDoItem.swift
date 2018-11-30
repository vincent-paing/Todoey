//
//  ToDoItem.swift
//  Todoey
//
//  Created by Vincent on 9/26/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
