//
//  Extensions+Date.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 1/9/2022.
//

import Foundation

extension Date {
    
    static func convertTimeStampToDate(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
}
