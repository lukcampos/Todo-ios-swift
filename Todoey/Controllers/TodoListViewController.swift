//
//  ViewController.swift
//  Todoey
//
//  Created by Lucas Alves Campos on 19/02/19.
//  Copyright © 2019 Lucas Alves Campos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    
   // let defaults = UserDefaults.standard
    
    let dataFilePath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
          loadItems()
        
        //print(dataFilePath)
        
       
        
//        if let items  =  defaults.array(forKey: "TodoListArray") as?  [Item] {
//            itemArray = items
//        }
//        
        
//        for item in 0...40 {
//            let newItem = Item()
//            newItem.title = "Almoçar com o Rodrigo \(item)"
//            itemArray.append(newItem)
//        }
       

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = "\(itemArray[indexPath.row].title)"

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
            
            let newItem = Item()
            newItem.title = textField.text!
          //  newItem.done = false;
            
            self.itemArray.append(newItem)
            
            
            self.saveItems()
            
            
            
            
          //  self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error enconding")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                 itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                
            }
           
        }
        
    }
    
    
}

