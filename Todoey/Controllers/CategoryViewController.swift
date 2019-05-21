//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lucas Alves Campos on 20/05/19.
//  Copyright © 2019 Lucas Alves Campos. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

 var categoryArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }



    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = "\(categoryArray[indexPath.row].name!)"
        
        return cell
        // UITableViewCell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(categoryArray[indexPath.row])")
        
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath =  tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK -  Add new item
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            
            
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.categoryArray.append(newItem)
            
            
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
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest() ){
        
        do{
            categoryArray = try context.fetch(request)
            
        } catch {
            print("Error")
        }
        
        tableView.reloadData()
        
        
    }
    
    

    
}
