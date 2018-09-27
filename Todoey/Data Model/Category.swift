//
//  Category.swift
//  Todoey
//
//  Created by Vincent on 9/26/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<ToDoItem>()
}
