//
//  MasterTableViewController.swift
//  NotesApp
//
//  Created by Vaishak.Iyer on 13/04/18.
//  Copyright © 2018 Vaishak.Iyer. All rights reserved.
//

import UIKit

var objects:[String] = [String]();
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let keyNotes:String = "note"
let BLANK_NOTE:String = "(A New Note)"


class MasterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        masterView = self
        loadNotes()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if objects.count == 1
        {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        saveNotes()
        super.viewWillAppear(animated)
    }
    
    // Overwrite viewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        if objects.count == 0 {
            insertNewObject(sender: self)
        }
        // and call the inherited viewDidAppear() from the super class
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func insertNewObject(sender: AnyObject) {
        // [iPhone, landscape mode] Only allow to create new notes if not editing more (not allow to edit there)
        if detailViewController?.detailDescriptionLabel.isEditable == false {
            return
        }
        
        if objects.count == 0 ||  objects[0] != BLANK_NOTE {
            objects.insert(BLANK_NOTE, at: 0) // Default index = 0 (top one)
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
        currentIndex = 0 // Set the index to the default, top one
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        enableEditing()
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                currentIndex = indexPath.row
            }
            let object = objects[currentIndex]
            detailViewController?.detailItem = object as AnyObject
            detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            disableEditing() // Disable editing mode when deleting a note
            return
        }else
        {
            enableEditing()
        }
        saveNotes()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        disableEditing()
        saveNotes()
    }
    
    
    func saveNotes() {
        UserDefaults.standard.set(objects, forKey: keyNotes)
        UserDefaults.standard.synchronize() // Optional but very useful to automaticly save the note (without pressing the Home button)
    }
    
    func loadNotes() {
        if let loadNotes = UserDefaults.standard.array(forKey: keyNotes) as? [String] {
            // If there are notes to load
            objects = loadNotes
        }
    }
    
    func enableEditing() {
        detailViewController?.detailDescriptionLabel.isEditable = true
    }
    
    func disableEditing() {
        detailViewController?.detailDescriptionLabel.isEditable = false // Avoid users edit a deleted note
        detailViewController?.detailDescriptionLabel.text = "" // And then set empty string
    }
}
