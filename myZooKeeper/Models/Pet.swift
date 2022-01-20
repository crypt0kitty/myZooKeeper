//
//  Pet.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/11/21.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Pet {
    
    var petName: String
    var petWeight: String
    var petImageUrl: String
    var createdAt: Date

    init?(snapshot: QueryDocumentSnapshot) {
        petName = snapshot.data()["name"] as! String
        petWeight = snapshot.data()["weight"] as! String
        petImageUrl = snapshot.data()["petImageUrl"] as! String
        guard let timeInterval = snapshot.data()["createdAt"] as? TimeInterval else {
            return nil
        }
        createdAt = Date.convertTimeStampToDate(timeInterval)
    }
}
