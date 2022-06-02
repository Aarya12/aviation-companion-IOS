//
//  LoaderClass.swift
//  DemoServiceManage
//
//  Created by Zestbrains on 11/06/21.
//

import Foundation
import NVActivityIndicatorView
import UIKit
import Lottie


class LoadingDailog: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: - Shared Instance
    static let sharedInstance : LoadingDailog = {
        let instance = LoadingDailog()
        return instance
    }()
    
    func startLoader() {
        //.AppBlue()
        startAnimating(nil, message: nil, messageFont: nil, type: .ballRotateChase, color: .appColor, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    func stopLoader() {
        self.stopAnimating()
        
    }
}

class NewLoadingDailog: UIViewController {

    private var animationView: AnimationView?
    let BGView = UIView()

    //MARK: - Shared Instance
    static let sharedInstance : NewLoadingDailog = {
        let instance = NewLoadingDailog()
        return instance
    }()
    
    override func viewDidLoad(){
        
    }
    
    func startLoader() {
        
        animationView = .init(name: "LoaderAnimation")
        animationView!.frame = view.bounds
        animationView?.frame.size.width = ScreenSize.WIDTH - 200
        animationView?.frame.origin.x = 100
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 2.5
        //animationView!.backgroundColor = UIColor.white.withAlphaComponent(0.8)
       // view.addSubview(animationView!)
        
        BGView.frame = view.bounds
        BGView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        BGView.tag = 19171
        BGView.addSubview(animationView!)
        
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        if !BGView.isDescendant(of: keyWindow) {

            keyWindow.subviews.forEach { (vw) in
                if vw.tag == 19171 {
                    vw.removeFromSuperview()
                }
            }
            keyWindow.addSubview(BGView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animationView!.play()
        }
    }

    func stopLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animationView?.stop()
            self.animationView?.fadeOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animationView?.removeFromSuperview()
                self.BGView.removeFromSuperview()
            }
        }
    }
}


//MARK: HIDE/SHOW LOADERS
public func HIDE_CUSTOM_LOADER(){
    LoadingDailog.sharedInstance.stopLoader()
//    NewLoadingDailog.sharedInstance.stopLoader()
}
public func SHOW_CUSTOM_LOADER(){
    LoadingDailog.sharedInstance.startLoader()
//    NewLoadingDailog.sharedInstance.startLoader()
}

//MARK: Loading indicater and Alert From UIVIEWController
extension UIViewController {
    
    //MARK: - Show/Hide Loading Indicator
    func SHOW_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.startLoader()
//        NewLoadingDailog.sharedInstance.startLoader()
    }
    func HIDE_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.stopLoader()
//        NewLoadingDailog.sharedInstance.stopLoader()
    }
    
}
