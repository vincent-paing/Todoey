//
//  ToDoItem.swift
//  Todoey
//
//  Created by Vincent on 9/23/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import Foundation

class ToDoItem : Encodable, Decodable {
    
    var text = ""
    var isChecked = false
    
    init(text : String) {
        self.text = text
    }
    
}
