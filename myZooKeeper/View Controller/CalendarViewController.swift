//
//  CalendarViewController.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/16/21.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol RemindersDelegate: AnyObject {
    func fetchData()
}

class CalendarViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var reminders: [Reminder] = [Reminder]()
    var pullControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pullControl.backgroundColor = UIColor.white
        pullControl.tintColor = UIColor.systemRed
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
        spinner.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        getReminders()
    }
    
    func getReminders() {
        spinner.isHidden = false
        spinner.startAnimating()
        Firestore.firestore().collection("reminders").getDocuments { [weak self] (snapshot, error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.spinner.isHidden = true
                strongSelf.spinner.stopAnimating()
            }
            if error != nil {
                print("Error fetching reminders list!")
                let alert = Alerts.getAlert(title: "Error", message: "Error getting reminders")
                DispatchQueue.main.async {
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            } else {
                guard let documentSnapshot = snapshot, !documentSnapshot.isEmpty else {
                    print("Error fetching reminders list! May be empty list.")
                    return
                }
                let reminderDocuments = documentSnapshot.documents
                strongSelf.reminders = reminderDocuments.map({ snapshot in
                    return Reminder(snapshot: snapshot)
                })
                strongSelf.reminders.sort { reminderOne, reminderTwo in
                    reminderOne.reminderDate > reminderTwo.reminderDate
                }
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
    
    func getData(completion: @escaping ((_ success: Bool) -> Void)) {
        Firestore.firestore().collection("reminders").getDocuments { (snapshot, error) in
            if self.spinner.isAnimating {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
            }
            if error != nil {
                print("Error fetching reminders list!")
                completion(false)
            } else {
                guard let documentSnapshot = snapshot, !documentSnapshot.isEmpty else {
                    print("Error fetching reminders list! May be empty list.")
                    completion(false)
                    return
                }
                let reminderDocuments = documentSnapshot.documents

                self.reminders = reminderDocuments.map({ snapshot in
                    return Reminder(snapshot: snapshot)
                })
                completion(true)
            }
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        self.tableView.reloadData()
        self.pullControl.endRefreshing()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier:"AddReminderViewController") as! AddReminderViewController
        vc.remindersDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension CalendarViewController: RemindersDelegate {
    func fetchData() {
        getReminders()
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath)
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.getFormattedDate() + " - " + reminder.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            let alertController = UIAlertController(title: "Success", message: "Pet reminder deleted successfully!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            // Call completion handler to dismiss the action button
                self.reminders.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
                                            
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            completionHandler(true)
        }

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        editAction.backgroundColor = UIColor.systemYellow
        return swipeConfiguration
    }
}
