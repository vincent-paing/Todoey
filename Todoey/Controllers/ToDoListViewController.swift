//
//  ToDoListViewController
//  Todoey
//
//  Created by Vincent on 9/22/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var toDoItems : Results<ToDoItem>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK: Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item =  toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items are added"
        }
        
        return cell
    }

    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done update \(error)")
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
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
                self.addData(title: input)
            }
        }

        alert.addAction(addAction)

        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation
    func addData(title : String) {
        if let currentCategory = self.selectedCategory {
            do {
                try realm.write {
                    let newItem = ToDoItem()
                    newItem.title = title
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving item, \(error)")
            }
        }
        
        self.tableView.reloadData()
    }

    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
}
    
//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
