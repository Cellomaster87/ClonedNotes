//
//  FolderTableViewController.swift
//  ClonedNotes
//
//  Created by Michele Galvagno on 26/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    var notes = [Note]()
    var originIndexPath: IndexPath!
    var delegate: ViewController!
    
    let toolbarLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarLabel.font = toolbarLabel.font.withSize(12)
        toolbarLabel.textAlignment = .center
        toolbarLabel.text = "\(notes.count) notes"
        let labelButton = UIBarButtonItem(customView: toolbarLabel)
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        deleteButton.isEnabled = false
        
        toolbarItems = [deleteButton, flexibleSpace, labelButton, flexibleSpace, composeButton]
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].text

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Table view delegate methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(tableView.isEditing, animated: true)
        toolbarItems?.first?.isEnabled.toggle()
        toolbarItems?.last?.isEnabled.toggle()
    }
    
    // MARK: - Helper methods
    @objc func composeNote() {
        let note = Note(title: "Test title", text: "Testing the detail text item") // temporary before implementing next screen
        notes.append(note)
        toolbarLabel.text = "\(notes.count) notes"
        
        delegate.updateFolder(at: originIndexPath, with: notes)
        tableView.reloadData()
    }
    
    @objc func deleteNote() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let sortedRows = selectedRows.sorted { $0.row > $1.row }
            for indexPath in sortedRows {
                let rowToDelete = indexPath.row
                notes.remove(at: rowToDelete)
                toolbarLabel.text = "\(notes.count) notes"
            }
            
            delegate.updateFolder(at: originIndexPath, with: notes)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
        isEditing.toggle()
    }
}
