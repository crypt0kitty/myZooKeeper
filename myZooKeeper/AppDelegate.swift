//
//  AppDelegate.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/1/21.
//
import UIKit
import Firebase
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var db: Firestore! //optional will initialize later
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      UITextView.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Menlo"))
      
      UITextField.appearance().font = .systemFont(ofSize: 17)
      UITextView.appearance().font = .systemFont(ofSize: 16)
      UILabel.appearance().font = .boldSystemFont(ofSize: 17.0)

      if #available(iOS 15.0, *) {
          let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                     let appearance = UINavigationBarAppearance()
                     appearance.configureWithOpaqueBackground()
          appearance.titleTextAttributes = textAttributes
                     appearance.backgroundColor = UIColor.systemBlue// UIColor(red: 0.0/255.0, green: 125/255.0, blue: 0.0/255.0, alpha: 1.0)
//                     appearance.shadowColor = .clear  //removing navigationbar 1 px bottom border.
                     UINavigationBar.appearance().standardAppearance = appearance
                     UINavigationBar.appearance().scrollEdgeAppearance = appearance
      }

    FirebaseApp.configure()
        db = Firestore.firestore()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           return (GIDSignIn.sharedInstance()?.handle(url))!
       }
}




