//
//  ForgotPasswordViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 23/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class ForgotPasswordViewModel {
    
    var vc: UIViewController?
    
    var email: String = ""
    
    
    private func isValidate() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }

        if self.email.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.EmailNameMissing)
            return false
        }
        
        if !self.email.isValidEmail()  {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.ValidEmail)
            return false
        }
        
        return true
    }
    
    /// returns the parameters for the register
    private func getParams() -> [String: Any] {
        var params: [String: Any] =
        [
            kemail : email
        ]
        
        return params
    }

    
    // MARK: - API Call

    /// WSForgotPassword
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func WSForgotPassword(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .forgotPassword, parameters: self.getParams()) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
                        
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
