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
            headingLabel.numberOfLines = 0
            headingLabel.textColor = .systemBlue
            headingLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        }
    }

    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
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
        headingLabel.setSizeFont(sizeFont: 30, font: "Menlo")
        subHeadingLabel.setSizeFont(sizeFont: 17, font: "Hevlectica")
    }
}

extension UILabel {
    func setSizeFont (sizeFont: Int, font: String ) {
        self.font =  UIFont(name: self.font.familyName, size: CGFloat(sizeFont))!
        self.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeFont))
    }
}

