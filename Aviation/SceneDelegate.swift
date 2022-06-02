//
//  SceneDelegate.swift
//  Aviation
//
//  Created by Zestbrains on 09/11/21.
//

import UIKit
import IQKeyboardManagerSwift

import FacebookCore

@available(iOS 13.0, *)
let scene = UIApplication.shared.connectedScenes.first

@available(iOS 13.0, *)
let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate)!

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow

        self.window = UIWindow(windowScene: windowScene)
        
        if !(AviationUser.shared.id.isEmpty || AviationUser.shared.id == "") {
            setHomeScreen()

        }else {
            setLoginScreen()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

}


@available(iOS 13.0, *)
extension SceneDelegate {
    
    func setHomeScreen(index: Int = 2) {

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
            // maybe do something her
        })
    }
    
    func setLoginScreen() {
        
        let vc = storyBoards.LoginRegister.instantiateViewController(withIdentifier: "LoginNav")
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }, completion: { completed in
            // maybe do something here
        })
    }
}

