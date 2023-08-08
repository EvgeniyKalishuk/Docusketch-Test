//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Евгений Калишук on 7.08.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
        
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
                

        }catch{
            print("Error saving ")
        }
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
                        do{
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        }catch{
                            print("error with deletion")
                        }
        
                    }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
           
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
