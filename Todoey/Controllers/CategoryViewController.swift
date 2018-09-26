//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vincent on 9/26/18.
//  Copyright © 2018 Vincent. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: -  Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        
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
                let newCategory = Category(context: self.context)
                newCategory.name = input
                self.itemArray.append(newCategory)
                self.saveData()
            }
        }
        
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Data Manipulation method
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try itemArray = context.fetch(request)
        } catch {
            print("Error loading context, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Add Navigation
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ToDoListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationViewController.selectedCategory = itemArray[indexPath.row]
            }
        }
    }

}
