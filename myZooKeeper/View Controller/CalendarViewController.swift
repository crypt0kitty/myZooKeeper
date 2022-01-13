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

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var reminders: [Reminder] = [Reminder]()
    var pullControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pullControl.backgroundColor = UIColor.systemRed
        pullControl.tintColor = UIColor.white
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
        getData { [weak self] success in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.pullControl.endRefreshing()
            }
            if !success {
                let alert = Alerts.getAlert(title: "Error", message: "Pull to refresh failed")
                strongSelf.present(alert, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
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

extension CalendarViewController: UITableViewDelegate {
}

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath)
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.title + " created at " + reminder.getFormattedDate()
        cell.detailTextLabel?.text = reminder.description
        return cell
    }
    
}
