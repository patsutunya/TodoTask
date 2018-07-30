//
//  CategoryTableViewController.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/29/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
        
    }
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
       
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        cell.delegate = self
        
        return cell
    }
    
    // Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            //
            self.save(category: newCategory)
            
        }
   
        alert.addTextField { (alterTextField) in
            alterTextField.placeholder = "Create new category"
            textField = alterTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    // Mark: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
       
            try realm.write {
                realm.add(category)
            }
       
        }catch{
            
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Set NSFetchRequest<Category> = Category.fetchRequest() as parameter
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
   
    }
    
}

// MARK: - Swipe Cell Delegate Methods

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let categoryForDeletion = self.categoryArray?[indexPath.row]{
                do {
                    try self.realm.write {
                     self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting \(error)")
                }
                
                tableView.reloadData()
            }
            
    }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
  /* func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    } */
}

