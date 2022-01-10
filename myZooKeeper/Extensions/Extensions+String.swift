//
//  Extensions+String.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 1/9/2022.
//

import Foundation

extension String {
    
    func checkInput(greaterThan minLength: Int, lessThan maxLength: Int) -> Bool {
        if self.count > minLength {
            return true
        }
        if self.count < maxLength {
            return true
        }
        return true
    }
    
}
