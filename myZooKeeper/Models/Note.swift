//
//  Task.swift
//  myZooKeeper
//
//  Created by sandy vasquez on 1/14/22.
//
import Foundation
import Firebase
import FirebaseFirestore

struct Tasked {

    var petnote: String
   
    init?(snapshot: QueryDocumentSnapshot) {
        petnote = snapshot.data()["task"] as! String
      
        }
}
