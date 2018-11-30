//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vincent on 9/26/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: -  Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added yet"
        
        return cell
    }

    //MARK: - Add Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Shopping List"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let input = textField.text!
            
            if (!input.isEmpty) {
                self.addCategory(name: input)
            }
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Data Manipulation method
    func addCategory(name : String) {
        let newCategory = Category()
        newCategory.name = name
        save(category: newCategory)
    }
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ToDoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationViewController.selectedCategory = categories?[indexPath.row]
            }
        }
    }

}
