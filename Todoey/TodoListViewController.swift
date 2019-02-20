//
//  ViewController.swift
//  Todoey
//
//  Created by Lucas Alves Campos on 19/02/19.
//  Copyright © 2019 Lucas Alves Campos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray:[String] = ["Almoçar com o Rodrigo","Andar de bike","Completar 10% na Udemy"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items  =  defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = "\(itemArray[indexPath.row])"
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
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK -  Add new item
    
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            self.itemArray.append(textField.text!)
            
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
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
        
            present(alert, animated: true, completion:nil )
        
//        alert.addAc
    }
    
    
}

