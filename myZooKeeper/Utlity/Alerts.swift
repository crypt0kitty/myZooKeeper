//
//  Alerts.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 1/8/2022.
//

import Foundation
import UIKit

class Alerts {
    
    static func getAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
    
}


