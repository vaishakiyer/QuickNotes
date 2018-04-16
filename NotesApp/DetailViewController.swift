//
//  DetailViewController.swift
//  NotesApp
//
//  Created by Vaishak.Iyer on 13/04/18.
//  Copyright © 2018 Vaishak.Iyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if objects.count == 0 {
            return
        }
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            if label.text == BLANK_NOTE {
                label.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detailViewController = self
        detailDescriptionLabel.becomeFirstResponder() // Show the keyboard
        detailDescriptionLabel.delegate = self
      
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if objects.count == 0 {
            // If no note, stop the function here
            return
        }
        
        objects[currentIndex] = detailDescriptionLabel.text
        
        if detailDescriptionLabel.text == "" {
            objects[currentIndex] = BLANK_NOTE
        }
        
        saveAndUpdateNotes()
    }
    
    func saveAndUpdateNotes() {
        masterView?.saveNotes()
        masterView?.tableView.reloadData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
       // objects[currentIndex] = detailDescriptionLabel.text
        saveAndUpdateNotes()
    }
    
}


