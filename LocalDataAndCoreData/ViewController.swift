//
//  ViewController.swift
//  LocalDataAndCoreData
//
//  Created by Reynard Vincent Nata on 05/12/19.
//  Copyright © 2019 Reynard Vincent Nata. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var categories : [NoteCategory] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    @IBAction func addNoteTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "New Note"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let textField = alert.textFields![0]
            self.saveNote(text: textField.text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func saveNote(text: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
//        let category = NoteCategory(context: context)
//        category.name = "Song"
        
        let categori = categories[3]
        categori.name = "Lagu"
        
        let note = Note(context: context)
        note.content = text
        note.createdDate = Date()
        note.category = categori
        
//        category.notes = [note]
        
        do {
            try context.save()
            loadData()
        } catch {
            
        }
    }
    
    func loadData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = NoteCategory.fetchRequest()
//        let predicate = NSPredicate(format: "name == %@", "Movie")
        let sort = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        do{
            categories = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            
        }
    
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            if let note: Note = categories[indexPath.section].notes?[indexPath.row] as? Note{
                context.delete(note)
                loadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let note: Note = categories[indexPath.section].notes?[indexPath.row] as! Note? {
            cell.textLabel?.text = note.content
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MMM yyyy, HH:mm"
            cell.detailTextLabel?.text = dateformatter.string(from: note.createdDate!)
        }
        
        return cell
    }


}
