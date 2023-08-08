import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationController?.navigationBar.barTintColor = UIColor.green
    loadItems()
        tableView.rowHeight = 80.0
        
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            cell.accessoryType = item.isDone ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items added yet"
        }
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.itemArray?[indexPath.row] {
                        do{
                            try self.realm.write {
                                self.realm.delete(itemForDeletion)
                            }
                        }catch{
                            print("error with deletion")
                        }
        
                    }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {
                    item.isDone = !item.isDone
                }}catch{
                    print("error")
                }
        }
//        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
//
//
//
//        saveItems()
        
        
        
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {(action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                }catch{
                    print("error saving items \(error)")
                }
                
            }
            
            
                
                    
            self.tableView.reloadData()
            
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField}
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func loadItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
   
    
}

extension TodoListViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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
