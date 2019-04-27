//
//  NoteViewController.swift
//  ClonedNotes
//
//  Created by Michele Galvagno on 27/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    weak var delegate: FolderTableViewController!
    var originIndexPath: IndexPath!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        textView.text = note.text
        textView.font = textView.font?.withSize(18)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        toolbarItems = [shareButton, flexibleSpace]
        
        // Keyboard and insets management
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Helper methods
    @objc func done() {
        navigationController?.popViewController(animated: true)
        
        delegate.updateNote(at: originIndexPath, with: textView.text)
    }
    
    @objc func shareNote() {
        let shareVC = UIActivityViewController(activityItems: [note.title, "\n", note.text], applicationActivities: [])
        shareVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(shareVC, animated: true, completion: nil)
    }
    
    // Manage the keyboard state change
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue // tells us the size of the keyboard
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
