//
//  WalkthroughContentViewController.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/8/21.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 2
            headingLabel.textColor = .systemBlue
        }
    }

    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 3
        }
    }
            
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        headingLabel.setSizeFont(sizeFont: 20, font: "Menlo")

    }
}


extension UILabel {
    func setSizeFont (sizeFont: Int, font: String ) {
        self.font =  UIFont(name: self.font.familyName, size: CGFloat(sizeFont))!
        self.font = UIFont.boldSystemFont(ofSize: 30)
        
//        self.font =  UIFont(name: self.font.familyName, size: CGFloat(sizeFont))!
//        self.font = UIFont.boldSystemFont(ofSize: 30)
//
//
//

    }

}

// Use

