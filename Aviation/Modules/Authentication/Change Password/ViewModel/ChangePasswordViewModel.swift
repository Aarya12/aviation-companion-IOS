//
//  ChangePasswordViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 23/12/21.
//

import Foundation
import UIKit
import SwiftyJSON
import Toaster

class ChangePasswordViewModel {
    
    var vc: UIViewController?
    
    var oldPassword: String = ""
    var password: String = ""
    var confirmPassword : String = ""
    
    
    private func isValidate() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }

        
        if self.oldPassword.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordMissing)
            return false
        }

        if password.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.NewpasswordMissing)
            return false
        }

//        if password.count < 6 {
//            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordMinMissing)
//            return false
//        }

        if confirmPassword.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.ConfirmPasswordMissing)
            return false
        }

        if password != confirmPassword {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordNotMatch)
            return false
        }
        
        return true
    }
    
    /// returns the parameters for the register
    private func getParams() -> [String: Any] {
        var params: [String: Any] =
        [
            kOld_password : oldPassword,
            kPassword : password,
            kConfirmPassword : confirmPassword,
        ]
        
        return params
    }

    
    // MARK: - API Call

    /// WSChangePassword
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func WSChangePassword(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .ChangePassword, parameters: self.getParams()) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
            
            Toast(text: error).show()
            
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
    
}
