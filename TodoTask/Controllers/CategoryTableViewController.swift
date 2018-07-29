//
//  CategoryTableViewController.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/29/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
        }
   
        alert.addTextField { (alterTextField) in
            alterTextField.placeholder = "Create new category"
            textField = alterTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    // Mark: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
       
            try context.save()
       
        }catch{
            
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Set NSFetchRequest<Category> = Category.fetchRequest() as parameter
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
        categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
        // Set NSFetchRequest<Category> = Category.fetchRequest() outside function parameter
        /*
         func loadCategories() {
         let request : NSFetchRequest<Category> = Category.fetchRequest()
         do {
         categoryArray = try context.fetch(request)
         }catch {
         print("Error fetching data from context \(error)")
         }
         tableView.reloadData()
         } */
        
    }
    
    
    
    
    
    
    
    
    
}
