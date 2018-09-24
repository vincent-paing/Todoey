//
//  ToDoListViewController
//  Todoey
//
//  Created by Vincent on 9/22/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ToDoItem]()
    let ITEM_ARRAY_KEY = "TodoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        loadData()
    }
    
    //MARK: Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.text
        
        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        itemArray[indexPath.row].isChecked = !item.isChecked
        
        tableView.reloadData()
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Add New Items

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
                self.itemArray.append(ToDoItem(text: input))
                self.saveData()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

