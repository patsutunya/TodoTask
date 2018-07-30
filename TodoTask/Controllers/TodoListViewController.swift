//
//  ViewController.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/22/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import UIKit
import RealmSwift



class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet {
            
             loadItems()
        }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
   
        //loadItems()
        
  /* if let items = defualts.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items
        
    } */
        
}
    // MARK: - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary operator ==>
            // Value = condition ? valueIfTrue : valueIfFalse
            
            // short code form CHECKMARK function
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
        }
       
        
        // Ternary operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
       
        // short code form CHECKMARK function
        //cell.accessoryType = item.done == true ? .checkmark : .none
         // long code form CHECKMARK function
        /* if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        } */
        
        return cell
    }

    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
          
            do {
            try realm.write {
                
               
                item.done = !item.done
            }
            } catch {
                
                print("Error saving done status, \(error)")
            }
  
        }
        
        tableView.reloadData()
        
        
        // short code form DONE function
       //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        // saveItems()
        
        // long code form DONE function
      /*  if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        }else {
            itemArray[indexPath.row].done = false
        } */
        /* if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } */
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happe once the user clikcs the Add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
               
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }

                } catch {
                    
                    print("Error saving new items, \(error)")
            }
       
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
            
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manupulation Methods
    
 /*   func saveItems() {
        do {
          try  context.save()
     } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    } */
   
    func loadItems() {
        
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
      /*  let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory!.name)!)
        // optional binding to check addtionalPredicate
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        /*let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
          request.predicate = compoundPredicate */
        do {
        itemArray =  try context.fetch(request)
        }catch{
           print("Error fetching data from context \(error)")
        } */
    }
    
    /*  func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
       
        }
    } */
    
}
// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        searchBar.becomeFirstResponder()
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text?.count == 0 {
           loadItems()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
              
            }
        }
    }
}
