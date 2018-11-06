//
//  ViewController.swift
//  ToDoApp
//
//  Created by Alperen Ünal on 20.10.2018.
//  Copyright © 2018 Alperen Ünal. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        loadItems()
        
    }

    
    //Table-View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //Table-View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        
        if let item = toDoItems?[indexPath.row]{
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print("Error: \(error)")
            }
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        if let currentCategory = self.selectedCategory{
            do{
                try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
                }
            }
            catch{
                print("Error: \(error) ")
            }
        }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    
    
    func loadItems(){
       
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
       
        tableView.reloadData()
    }
    
    
}


//Search Bar Methods
extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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

