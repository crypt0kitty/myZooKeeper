//
//  Events.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 1/10/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Reminder {
    
    var title: String
    var description: String
    var reminderDate: Date
    
    init(snapshot: QueryDocumentSnapshot) {
        title = snapshot.data()["title"] as! String
        description = snapshot.data()["description"] as! String
        reminderDate = Date.convertTimeStampToDate(snapshot.data()["createdAt"] as! TimeInterval)
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, DD, YYYY"
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: reminderDate)
    }
    
 
}
