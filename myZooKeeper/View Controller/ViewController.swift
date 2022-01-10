////
////  ViewController.swift
////  myZooKeeper
////
////  Created by Sandy Vasquez on 2/1/21.
////
//import UIKit
//import FirebaseAuth
//import GoogleSignIn
//
//
//class ViewController: UIViewController, GIDSignInDelegate  {
////    @IBOutlet weak var signInButton: UILabel!
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        
//        GIDSignIn.sharedInstance().delegate = self
//        
//    }
//
//    @IBAction func googleAction(_ sender: Any) {
//        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.signIn()
//    }
//    
//    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error != nil {
//            return
//          }
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                            accessToken: authentication.accessToken)
//        
//        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
//            
//            if (error != nil){
//                return
//            }
//            
//        })
//        
//    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
//    
//}
//
//
//
