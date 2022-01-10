//
//  TaskInfoViewController.swift
//  myZooKeeper
//
//  Created by Ada on 2/16/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class TaskInfoViewController: UIViewController {

    @IBOutlet var label: UILabel!
    var task: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
//        let newCount = count - 1
//        UserDefaults().setValue(newCount, forKey: "count")
//        UserDefaults().setValue(nil, forKey: "task_\(currentPosition)")
    }

}
