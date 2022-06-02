//
//  AddStudentViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 31/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class AddStudentViewModel {

    var vc: UIViewController?

    var certificateID : Int = 0
    var name : String = ""
    var email: String = ""

    private func isValidate(isSocialRegister : Bool = false) -> Bool {
        
        guard let vc = self.vc else {
            return false
        }

        if self.name.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.NameMissing)
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
        

        if certificateID == 0 {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.CertificateMissing)
            return false
        }

        return true
    }

    /// returns the parameters for the register
    private func getRegisterParamsValues() -> [String: Any] {
        var params: [String: Any] =
        [
            kName : name,
            kemail : email,
            kCertificate_id : certificateID
        ]
        return params
    }

}

extension AddStudentViewModel {
    
    /// AddStudentAPI
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func AddStudentAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .addStudentViaEmail, parameters: self.getRegisterParamsValues()) { response, isSuccess, error, statusCode in

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
