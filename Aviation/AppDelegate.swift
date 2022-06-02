//
//  AppDelegate.swift
//  Aviation
//
//  Created by Zestbrains on 09/11/21.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import FacebookCore
import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceToken:String = ""

    //403034250349-7ca6f76vn1fplqrdpgehv9ovven85tc9.apps.googleusercontent.com
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

       // setSplash(isAppFromAppDelegate: true)
        sleep(2)
        self.getAirports()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow

        application.applicationIconBadgeNumber = 0
        
        FirebaseApp.configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if !(AviationUser.shared.id.isEmpty || AviationUser.shared.id == "") {
            setHomeScreen(isAppFromAppDelegate: true)
        }else {
            setLoginScreen(isAppFromAppDelegate: true)
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        //for Google Login
        let handled: Bool = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }

        //for facebook
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }

}

//Navigations
extension AppDelegate {
    /// this functions is set login screen as root
    func setLoginScreen(isAppFromAppDelegate : Bool = false){
        
        AviationUser.shared.clear()
        
        if #available(iOS 13.0, *) ,(isAppFromAppDelegate == false){
            sceneDelegate.setLoginScreen()
        }else {
            
            let vc = storyBoards.LoginRegister.instantiateViewController(withIdentifier: "LoginNav")
            
            UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }, completion: { completed in
                // maybe do something here
            })
        }
    }

    func setHomeScreen(isAppFromAppDelegate : Bool = false, index: Int = 2){
        if #available(iOS 13.0, *) , (isAppFromAppDelegate == false){
            sceneDelegate.setHomeScreen(index: index)
        }else {
            
            let studentEditProfileVC = storyBoards.Student.instantiateViewController(withIdentifier: "EditStudentsVC") as! EditStudentsVC
            studentEditProfileVC.isFromFillRemainingData = true

            let InstructorEditProfileVC = storyBoards.Home.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            InstructorEditProfileVC.isFromFillRemainingData = true

            let homeVC = storyBoards.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            
            var vc : UIViewController = homeVC
 
//            if index != 0 {
//                vc.selectIndxAt = index
//            }
            
            if AppSelectedUserType == .Student {
                
                if (AviationUser.shared.certificateId == nil) {
                    vc = studentEditProfileVC
                }
                
            }else {
                if (AviationUser.shared.experienceInYear == nil || AviationUser.shared.approxHours == nil || AviationUser.shared.airportId == nil) || (AviationUser.shared.experienceInYear == 0 || AviationUser.shared.approxHours.isEmpty || AviationUser.shared.airportId == 0) {
                    
                    vc = InstructorEditProfileVC
                }
            }


            UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true

                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }, completion: { completed in
                // maybe do something here
            })
        }
    }
}


//MARK: - General Function
extension AppDelegate {
    
    func getAirports(offset : Int = 0) {
        
        AviationsViewModel.shared.offset = offset
        
        DispatchQueue.global(priority: .low).asyncAfter(deadline: .now() + 0.3, execute: {
            
            AviationsViewModel.shared.getAviations(keywords: "") { response in

                if AviationsViewModel.shared.hasMoreData {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        appDelegate.getAirports(offset: AviationsViewModel.shared.arrAviations.count)
                    }
                }
                
            } failure: { errorResponse in
                
            }

        })
    }
}
