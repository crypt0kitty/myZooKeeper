//
//  WalkthroughViewController.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/9/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class WalkthroughViewController: UIViewController {

    //MARK:- Interface Builder
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:- Properties
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
}

//MARK:- Button Actions
extension WalkthroughViewController {
    @IBAction func loginButtonTap() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//MARK:- WalkthroughPageViewControllerDelegate Delegate Methods
extension WalkthroughViewController: WalkthroughPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        pageControl.currentPage = currentIndex
    }
}

//MARK:- Google SignIn Delegate Methods
extension WalkthroughViewController:  GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
          }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
            
            if (error != nil){
                print("SignIn Error!")
                print(error!)
                UserDefaults.standard.setValue(true, forKey: "isSignedIn")
                return
            } else {
                print("SignIn Complete!")
                UserDefaults.standard.setValue(true, forKey: "isSignedIn")
                self.dismiss(animated: true, completion: nil)
            }
            
        })
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}


