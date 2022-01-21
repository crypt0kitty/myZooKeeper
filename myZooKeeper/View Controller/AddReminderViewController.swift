//
//  AddReminderViewController.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 1/10/2022.
//
import UIKit
import FirebaseFirestore
import Firebase

class AddReminderViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var remindersDelegate: RemindersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                          let appearance = UINavigationBarAppearance()
                          appearance.configureWithOpaqueBackground()
               
               appearance.titleTextAttributes = textAttributes
                          appearance.backgroundColor = UIColor.systemRed
                          UINavigationBar.appearance().standardAppearance = appearance
                          UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (titleTextField != nil) {
            descriptionTextView.becomeFirstResponder()
            } else {
                descriptionTextView.resignFirstResponder()
            }
        
        return true
        }

    @IBAction func submitButtonDidTap(_ sender: Any) {
        
        guard let titleText = titleTextField.text else {
            presentAlert(title: "No Title", message: "Please add a title")
            return
        }
        guard let descriptionText = descriptionTextView.text else {
            presentAlert(title: "No Description", message: "Please add a description")
            return
        }
        
        let result = titleText.checkInput(greaterThan: 5, lessThan: 40)
        print("the result is")
        print(result)
        
        if !titleText.checkInput(greaterThan: 5, lessThan: 40) {
            presentAlert(title: "Title Too Long or Short", message: "Title must be 5 to 40 characters long")
            return
        }
        
        if !descriptionText.checkInput(greaterThan: 5, lessThan: 60) {
            presentAlert(title: "Description Too Long or Short", message: "Description must be 5 to 60 characters long")
            return
        }
        
        let reminderDateTimestamp = datePicker.date.timeIntervalSince1970
        
        let uid = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("reminders").addDocument(data: [
            "title": titleText,
            "description": descriptionText,
            "userId": uid,
            "createdAt": reminderDateTimestamp
        ]) { [weak self] err in
            guard let strongSelf = self else { return }
            if let err = err {
                print("Error adding document: \(err)")
                strongSelf.presentAlert(title: "Error", message: "There was an error adding a reminder. Please try again later.")
            } else {
                DispatchQueue.main.async {
                    strongSelf.remindersDelegate?.fetchData()
                    strongSelf.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
