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
    var directories: [Directory] = [Directory(name: "iCloud", folders: [Folder(name: "Notes", notes: [], itemsCount: 0)])]

    // MARK: - View's management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = editButtonItem
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteRows))
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        deleteButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New directory", style: .plain, target: self, action: #selector(createNewDirectory))
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    // MARK: - Action methods
    @IBAction func newFolderTapped(_ sender: Any) {
        if directories.count <= 1 {
            let newFolderAC = UIAlertController(title: "New folder", message: "Type a name for this folder", preferredStyle: .alert)
            newFolderAC.addTextField()
            let textField = newFolderAC.textFields?[0]
            textField?.placeholder = "Name"
            
            newFolderAC.addAction(UIAlertAction(title: "Save", style: .default) {
                [weak self, weak textField] _ in
                guard let folderName = textField?.text else { return }
                let newFolder = Folder(name: folderName, notes: [], itemsCount: 0)
                self?.directories[0].folders.insert(newFolder, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            })
            
            newFolderAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(newFolderAC, animated: true, completion: nil)
        } else {
            let directoryChooserAC = UIAlertController(title: "New folder", message: "Where do you want to add the folder?", preferredStyle: .actionSheet)
            for (index, directory) in directories.enumerated() {
                directoryChooserAC.addAction(UIAlertAction(title: directory.name, style: .default, handler: { [weak self] (action) in
                    let newFolderAC = UIAlertController(title: "New folder", message: "Type a name for this folder", preferredStyle: .alert)
                    newFolderAC.addTextField()
                    
                    let textField = newFolderAC.textFields?[0]
                    textField?.placeholder = "Name"
                    
                    newFolderAC.addAction(UIAlertAction(title: "Save", style: .default) {
                        [weak self, weak textField] _ in
                        guard let folderName = textField?.text else { return }
                        let newFolder = Folder(name: folderName, notes: [], itemsCount: 0)
                        self?.directories[index].folders.insert(newFolder, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: index)
                        self?.tableView.insertRows(at: [indexPath], with: .automatic)
                    })
                    
                    newFolderAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(newFolderAC, animated: true, completion: nil)
                }))
            }
            present(directoryChooserAC, animated: true, completion: nil)
        }
    }
    
    @objc func createNewDirectory() {
        let newDirectoryAC = UIAlertController(title: "New directory", message: "Type a name for the directory", preferredStyle: .alert)
        newDirectoryAC.addTextField()
        let textField = newDirectoryAC.textFields?[0]
        textField?.placeholder = "Name"
        
        newDirectoryAC.addAction(UIAlertAction(title: "Save", style: .default) {
            [weak self, weak textField] _ in
            guard let directoryName = textField?.text else { return }
            let newDirectory = Directory(name: directoryName, folders: [])
            self?.directories.insert(newDirectory, at: 0)
            
            self?.tableView.reloadData()
        })
        
        newDirectoryAC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(newDirectoryAC, animated: true, completion: nil)
    }
    
    @objc func deleteRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let rowToDelete = indexPath.row
                directories[indexPath.section].folders.remove(at: rowToDelete)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    // MARK: - Helper methods
    
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return directories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return directories[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories[section].folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Folder", for: indexPath)
        cell.textLabel!.text = directories[indexPath.section].folders[indexPath.row].name
        cell.detailTextLabel!.text = String(directories[indexPath.section].folders[indexPath.row].itemsCount)
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
        toolbarItems?[1].isEnabled.toggle()
        navigationItem.rightBarButtonItems?[1].isEnabled.toggle()
    }
}
