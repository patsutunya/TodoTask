//
//  ViewController.swift
//  TodoTask
//
//  Created by Patrick Sutunya on 7/22/18.
//  Copyright © 2018 psutunya. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    // use this line to print out the filepath in console putting on viewDidLoad
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
   
        loadItems()
        
  /* if let items = defualts.array(forKey: "TodoListArray") as? [Item] {
            
            itemArray = items
        
    } */
        
}
    // MARK: - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
       
        // short code form CHECKMARK function
        cell.accessoryType = item.done == true ? .checkmark : .none
        
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
        
        
        
        // short code form DONE function
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
         saveItems()
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
          
          /*  let encoder = PropertyListEncoder()

            do {
            let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
                
            }
            
            self.tableView.reloadData() */
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
            
           
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manupulation Methods
    
    func saveItems() {
        
        do {
            
          try  context.save()
            
        } catch {
           
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
    }
   
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() ) {
        
       
        do {
        itemArray =  try context.fetch(request)
        }catch{
           print("Error fetching data from context \(error)")
            
        }
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
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
       
    
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
