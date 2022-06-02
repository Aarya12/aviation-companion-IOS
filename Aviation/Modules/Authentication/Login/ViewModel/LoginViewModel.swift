//
//  LoginViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 20/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class LoginViewModel {
    
    var vc: UIViewController?
    
    var password: String = ""
    var email: String = ""
    var deviceType: String = "ios"
    var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var pushToken : String = appDelegate.deviceToken    
    
    func isValidate() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }
        
        if self.email == "" {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.EmailNameMissing)
            return false
        } else if !self.email.isValidEmail()  {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.ValidEmail)
            return false
        } else if self.password == "" {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordMissing)
            return false
        }
        return true
    }
    
    func getLoginParamsValues() -> [String: Any] {
        var params: [String: Any] = [:]
        
        params[kemail] = email
        params[kPassword] = password
        params[kDeviceType] = deviceType
        params[kDeviceID] = deviceID
        params[kPushToken] = pushToken
        params[kRole] = AppSelectedUserType.rawValue
        
        return params
    }
}


//MARK: - WEBSERVICE CALLS
extension  LoginViewModel {
    
    /// registerapi
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func loginAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .login, parameters: self.getLoginParamsValues()) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            AviationUser.shared.setData(dict: response["data"])
            
            if isSuccess == true {
                success(response)
            } else {
                failure(response)
            }
            
        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    
    
    /// CheckSocialAvaibility
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func CheckSocialAvaibility(isShowLoader : Bool = true, params : [String : Any], success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .checkSocialAvaibilty, parameters: params) { response, isSuccess, error, statusCode in
            
            print("Success Response:", response)
            
            if isSuccess == true {
                AviationUser.shared.setData(dict: response["data"])
                
                success(response)
            } else {
                failure(response)
            }
            

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            
            failure(response)
        }
    }
}

