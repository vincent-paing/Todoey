//
//  ToDoListViewController
//  Todoey
//
//  Created by Vincent on 9/22/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    let defaults = UserDefaults.standard
    let ITEM_ARRAY_KEY = "TodoListArray"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: ITEM_ARRAY_KEY) as? [String] {
            itemArray = items
        }
    }
    
    //MARK - Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK : Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Buy milk"
        }
        
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let input = textField.text!
            
            if (!input.isEmpty) {
                self.itemArray.append(input)
                self.tableView.reloadData()
                self.defaults.set(self.itemArray, forKey: self.ITEM_ARRAY_KEY)
            }
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
}

