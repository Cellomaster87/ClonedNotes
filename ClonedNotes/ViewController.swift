//
//  ViewController.swift
//  ClonedNotes
//
//  Created by Michele Galvagno on 22/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: - Outlets & Properties
    var folders: [[String]] = [["Notes"]]
    var headers: [String?] = ["iCloud"]

    // MARK: - View's management
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "Folders"
    }
    
    // MARK: - Action methods
    @IBAction func editTapped(_ sender: Any) {
    }
    
    @IBAction func newFolderTapped(_ sender: Any) {
        let newFolderAC = UIAlertController(title: "New folder", message: "Type a name for this folder", preferredStyle: .alert)
        newFolderAC.addTextField()
        let textField = newFolderAC.textFields?[0]
        textField?.placeholder = "Name"
        
        newFolderAC.addAction(UIAlertAction(title: "Save", style: .default) {
            [weak self, weak textField] _ in
            guard let noteTitle = textField?.text else { return }
            
            self?.folders[0].insert(noteTitle, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        })
        
        newFolderAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(newFolderAC, animated: true, completion: nil)
    }
    
    // MARK: - Helper methods
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel!.text = folders[indexPath.section][indexPath.row]
        cell.detailTextLabel!.text = "0" // temporary
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }


}

