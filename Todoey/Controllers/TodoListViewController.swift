//
//  ViewController.swift
//  Todoey
//
//  Created by Lucas Alves Campos on 19/02/19.
//  Copyright © 2019 Lucas Alves Campos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var  selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        

        
        
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = "\(itemArray[indexPath.row].title!)"

        return cell
       // UITableViewCell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(itemArray[indexPath.row])")
        
       // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if  itemArray[indexPath.row].done == true{
             itemArray[indexPath.row].done = false
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }else{
              itemArray[indexPath.row].done = true
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
        tableView.deselectRow(at: indexPath, animated: true)
        
      
        saveItems()
       
      
    }

    //MARK -  Add new item
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            
            self.saveItems()
            
            
            
            print("Success",textField.text!)
            self.tableView.reloadData()
            
            // what happen once users click add item
            
       
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
            
        }
        
        alert.addAction(action)
            present(alert, animated: true, completion:nil)
    }
    
    func saveItems(){
        
        do {
           try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil ){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let aditionalPfedicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,aditionalPfedicate])
        } else{
             request.predicate = categoryPredicate
        }
        
    
       
        do{
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error")
        }
        
         tableView.reloadData()
        
        
    }
    
    

    
    
}



//MARK: - Search Bar Mathods
extension TodoListViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let predicate = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //        do{
        //            itemArray = try context.fetch(request)
        //
        //        } catch {
        //            print("Error")
        //        }
        //
        //        tableView.reloadData()
        
        loadItems(with: request, predicate:predicate)
        
        print(searchBar.text!)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}

