//
//  TasksViewController.swift
//  myZooKeeper
//
//  Created by Ada on 2/16/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class TasksViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var tasklist: UITableView!
    var tasks = [String]()
    var pullControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        self.title = "Notes"
        pullControl.backgroundColor = UIColor.white
        pullControl.tintColor = UIColor.systemRed
        pullControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tasklist.refreshControl = pullControl
        } else {
            tasklist.addSubview(pullControl)
        }
        spinner.isHidden = true
        tasklist.delegate = self
        tasklist.dataSource = self
        updateTasks()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.tasklist.reloadData()
        self.pullControl.endRefreshing()
    }
    
    func updateTasks() {
        tasks = [String]()
        
        Firestore.firestore().collection("tasks-list").order(by: "task", descending: false ).getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error fetching tasks list!")
                } else {
                    guard let documentSnapshot = snapshot, !documentSnapshot.isEmpty else {
                        print("Error fetching pet list! May be empty list.")
                        return
                    }
                    
                    let taskDocuments = documentSnapshot.documents
                    
                    for document in taskDocuments {
                        let task = document.data()["task"] as! String
                        self.tasks.append(task)
                    }
                    
                    DispatchQueue.main.async {
                        self.tasklist.reloadData()
                    }
                }
            }
    }
    
    @IBAction func didTapAdd() {
        //show another view controller to make an entry
        let vc = storyboard?.instantiateViewController(identifier:"entry") as! EntryViewController
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier:"taskinfo") as! TaskInfoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
    
extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            let alertController = UIAlertController(title: "Success", message: "Pet note deleted successfully!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            // Call completion handler to dismiss the action button
                self.tasks.remove(at: indexPath.row)
                self.tasklist.deleteRows(at: [indexPath], with: .fade)
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


