//
//  LoginVC.swift
//  Aviation
//
//  Created by Zestbrains on 09/11/21.
//

import UIKit
import FacebookCore
import FacebookLogin
import SwiftyJSON
import GoogleSignIn

class LoginVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var txtEmail: AppCommonTextField!
    @IBOutlet weak var txtPassword: AppCommonTextField!
    
    @IBOutlet weak var btnLogin: EMButton! {
        didSet
        {
            btnLogin.btnType = .Submit
        }
    }
    
    //MARK: - VARIABLES
    private var loginViewmodel = LoginViewModel()
    private let appleSignIn = HSAppleSignIn()

    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnLoginClicks(_ sender: Any) {
        self.addDataIntoModel()
        
        self.loginViewmodel.loginAPI { _ in
            
            appDelegate.setHomeScreen()
            
        } failure: { _ in
            //failure
        }
    }
    
    @IBAction func btnForgotPasswordClicks(_ sender: Any) {
        self.pushTo("ForgotPasswordVC")
    }
    
    @IBAction func btnRegisterClicks(_ sender: Any) {
        self.pushTo("RegisterVC")
    }
    
    @IBAction func fbLoginClicks(_ sender: Any) {
        self.FaceBookLogin()
    }
    
    @IBAction func btnGoogleLoginClicks(_ sender: Any) {
        self.GoogleLogin()
    }
    
    @IBAction func btnAppleLoginClicks(_ sender: Any) {
        
        addDataIntoModel()
        
        self.AppleSignINBlock()
    }
    
}

//MARK: - GENERAL METHODS
extension  LoginVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        loginViewmodel.vc = self
        self.loginViewmodel.email = self.txtEmail.text ?? ""
        self.loginViewmodel.password = self.txtPassword.text ?? ""
    }
    
}


//MARK: - APPLE LOGIN
extension LoginVC {
    
    //by this function Add apple button
    private func AppleSignINBlock() {
        
        appleSignIn.didTapLoginWithApple()
        appleSignIn.appleSignInBlock = { (userInfo, message) in
            if let userInfo = userInfo{
                print(userInfo.email)
                print(userInfo.userid)
                print(userInfo.firstName)
                print(userInfo.lastName)
                print(userInfo.fullName)
                
                var parameter = [String:Any]()
                parameter[kType] = kApple
                parameter[kSocialID] = userInfo.userid
                parameter[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
                parameter[kDeviceType] = kiOS
                parameter[kPushToken] = appDelegate.deviceToken
                parameter[kemail] = userInfo.email
                parameter[kName] = userInfo.firstName + " " + userInfo.lastName
                
                //checkExist == 0 then it is register if user not exists and login, checkExist == 1 only check
                self.loginViewmodel.CheckSocialAvaibility(params: parameter) { response in
                    
                    appDelegate.setHomeScreen()
                    
                } failure: { errorResponse in
                    
                    if (errorResponse["status"].intValue == 412) && (errorResponse["message"].stringValue == "you need to register") {
                        
                        let registerVC = storyBoards.LoginRegister.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                        registerVC.isFromSocialRegister = true
                        registerVC.socialRegisterDict = parameter
                        self.navigationController?.pushViewController(registerVC, animated: true)
                    }
                }

            }else if let message = message{
                print("Error Message: \(message)")
                showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME , andMessage: "\(message)", buttons: ["Dismiss"]) { (i) in
                }
                
                return
            }else{
                print("Unexpected error!")
            }
        }
    }
}

//MARK: - FACEBOOOK Login
extension LoginVC {
    
    private func FaceBookLogin()
    {
        
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions:   ["public_profile", "email"], from: self) { (fbloginresult, error) -> Void in
            
            if (error == nil) {
                
                guard fbloginresult != nil else {
                    return
                }
                
                let permissionDictionary = [
                    "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
                let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
                
                pictureRequest.start { connection, result, error in
                    
                    if error == nil {
                        guard let result = result else { return }
                        
                        let results = JSON(result)
                        print("Logged in : \(String(describing: results))")
                        
                        //let profile = results["picture"]
                        let data = results["picture"]["data"]
                        
                        var parameters = [String:Any]()
                        parameters[kName] = results["name"].stringValue
                        parameters[kemail] = results["email"].stringValue
                        //parameters[kProfileImage] = data["url"].stringValue
                        parameters[kSocialID] = results["id"].stringValue
                        parameters[kType] = kFaceBook
                        
                        parameters[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
                        parameters[kDeviceType] = kiOS
                        parameters[kPushToken] = appDelegate.deviceToken
                        
                        self.loginViewmodel.CheckSocialAvaibility(params: parameters) { response in
                            
                            appDelegate.setHomeScreen()
                            fbLoginManager.logOut()
                            
                        } failure: { errorResponse in
                            
                            if (errorResponse["status"].intValue == 412) && (errorResponse["message"].stringValue == "you need to register") {
                                
                                let registerVC = storyBoards.LoginRegister.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                                registerVC.isFromSocialRegister = true
                                registerVC.socialRegisterDict = parameters
                                self.navigationController?.pushViewController(registerVC, animated: true)
                            }
                        }
                        
                    } else {
                        
                        print("error \(String(describing: error.debugDescription))")
                    }
                }
                
                let manager = LoginManager()
                manager.logOut()
            }
        }
    }
}

//MARK: - GOOGLE LOGINs
extension  LoginVC {
    
    func GoogleLogin() {
        
        let signInConfig = GIDConfiguration.init(clientID: googleClientKey)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            DispatchQueue.main.async {
                self.HIDE_CUSTOM_LOADER()
            }
            guard error == nil else { return }
            
            var registerDetail = [String:Any]()
            registerDetail[kName] = user?.profile?.name ?? ""
            registerDetail[kemail] = user?.profile?.email ?? ""
            registerDetail[kSocialID] = user?.userID ?? ""
            registerDetail[kType] = kGoogle
            registerDetail[kDeviceID] = UIDevice.current.identifierForVendor?.uuidString ?? ""
            registerDetail[kDeviceType] = kiOS
            registerDetail[kPushToken] = appDelegate.deviceToken
//            self.profileImageURL = user?.profile?.imageURL(withDimension: 1024)?.absoluteString ?? ""
            
            DispatchQueue.main.async {
                self.loginViewmodel.CheckSocialAvaibility(params: registerDetail) { response in
                    
                    appDelegate.setHomeScreen()
                    
                    GIDSignIn.sharedInstance.signOut()
                    
                } failure: { errorResponse in
                    
                    if (errorResponse["status"].intValue == 412) && (errorResponse["message"].stringValue == "you need to register") {
                        
                        let registerVC = storyBoards.LoginRegister.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                        registerVC.isFromSocialRegister = true
                        registerVC.socialRegisterDict = registerDetail
                        self.navigationController?.pushViewController(registerVC, animated: true)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        GIDSignIn.sharedInstance.signOut()
                    }
                }
            }
        }
    }
}
