//
//  EntryViewController.swift
//  myZooKeeper
//
//  Created by Ada on 2/16/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var field: UITextField!
    var update: (() -> Void)? //warning: Replace '(Void)' with '()'

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
  
    @objc func saveTask() {
        
        update?()
        navigationController?.popViewController(animated:true)
        
        var ref: DocumentReference? = nil
        let uid = Auth.auth().currentUser!.uid
        
        ref = Firestore.firestore().collection("tasks-list").addDocument(data: [
            "userId": uid,
            "task": self.field.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                /*
                 Show alert when adding a pet note
                 */
                let alert = UIAlertController(title: "Success", message: "Pet note added successfully!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
         }
       }
    }    
}
