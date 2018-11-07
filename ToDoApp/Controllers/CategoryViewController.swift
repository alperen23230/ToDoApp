//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Alperen Ünal on 5.11.2018.
//  Copyright © 2018 Alperen Ünal. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
   
        tableView.separatorStyle = .none
        
    }

    
  //Save-Load-Delete Methods
    
    func saveCategories(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
       
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            
            do{
                    try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                            }
                        }
                    catch{
                        print("Error: \(error)")
                }
            }
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.saveCategories(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert,animated: true,completion: nil)
        
    }
    
    
    
    
    //Table View data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name 
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            
            cell.backgroundColor = categoryColour
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        
        return cell
        
    }
    
    
    //Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}


