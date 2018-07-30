//
//  CategoryTableViewController.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/29/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        loadCategories()
    }
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
       
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
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
