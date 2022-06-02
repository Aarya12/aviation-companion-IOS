//
//  RegisterViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 22/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class RegisterViewModel {
    
    var vc: UIViewController?
    
    var name : String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword : String = ""
    var approxHours : String = ""
    var experience_in_year : String = ""
    var ratePerHour : String = ""
    var airPortID : Int = 0
    var certificateID : Int = 0
    
    var socialParams : [String : Any] = [:]
    
    var deviceType: String = "ios"
    var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var pushToken : String = appDelegate.deviceToken
    
    
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
        
        if isSocialRegister == false {
            if self.password.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordMissing)
                return false
            }

            if self.password.count < 6 {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordMinMissing)
                return false
            }

            if self.confirmPassword.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.ConfirmPasswordMissing)
                return false
            }

            if password != confirmPassword {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.PasswordNotMatch)
                return false
            }
        }
        
        
        if AppSelectedUserType == .Student {
            
            if certificateID == 0 {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.CertificateMissing)
                return false
            }
        }else {
            if approxHours.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.ApproxHoursMissing)
                return false
            }

            if experience_in_year.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.experienceMissing)
                return false
            }

            if ratePerHour.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.RatePerHourMissing)
                return false
            }

            if airPortID == 0 {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.BaseAirPortMissing)
                return false
            }
        }

        return true
    }
    
    /// returns the parameters for the register
    private func getRegisterParamsValues() -> [String: Any] {
        var params: [String: Any] =
        [
            kName : name,
            kemail : email,
            kPassword : password,
            kConfirmPassword : confirmPassword,
            kDeviceType : deviceType,
            kDeviceID : deviceID,
            kPushToken : pushToken,
            kRole : AppSelectedUserType.rawValue,
        ]

        if AppSelectedUserType == .Student {
            params[kCertificate_id] = certificateID
        }else {
            params[kApprox_Hours] = approxHours
            params[kExperience_in_year] = experience_in_year
            params[kRate_per_hour] = ratePerHour
            params[kAirport_id] = airPortID
        }
            
        return params
    }
    
    /// returns the parameters for the register
    private func getSocialRegisterParamsValues() -> [String: Any] {

        var params: [String: Any] = self.socialParams
        params[kName] = name
        params[kemail] = email
        params[kPassword] = password
        params[kConfirmPassword] = confirmPassword
        params[kDeviceType] = deviceType
        params[kDeviceID] = deviceID
        params[kPushToken] = pushToken
        params[kRole] = AppSelectedUserType.rawValue
        

        if AppSelectedUserType == .Student {
            params[kCertificate_id] = certificateID
        }else {
            params[kApprox_Hours] = approxHours
            params[kExperience_in_year] = experience_in_year
            params[kRate_per_hour] = ratePerHour
            params[kAirport_id] = airPortID
        }
            
        return params
    }

}

// MARK: - API Call
extension  RegisterViewModel {
        
    /// registerapi
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func RegisterAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .signup, parameters: self.getRegisterParamsValues()) { response, isSuccess, error, statusCode in

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

    
    func SocialRegisterAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate(isSocialRegister: true) ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .SocialRegister, parameters: self.getSocialRegisterParamsValues()) { response, isSuccess, error, statusCode in

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

}
