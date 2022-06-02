//
//  ProfileViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 29/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewModel {
    
    var vc: UIViewController?
    var profileModel : ModelProfileMain!
    
    var userID : Int = 0
    var profileImgData : Data?
    var name : String = ""
    var email: String = ""
    var approxHours : String = ""
    var experience_in_year : String = ""
    var ratePerHour : String = ""
    var airPortID : Int = 0
    var backStory : String = ""
    //for student
    var certificateID : Int = 0
    var countryCode : String = ""
    var mobile : String = ""
    var FTN : String = ""
    var HomeAirportID : Int = 0
    
    private func isValidate() -> Bool {
        
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
        
        if AppSelectedUserType == .Student {
            
            if self.mobile.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.MobileMissing)
                return false
            }

            if self.FTN.isEmpty {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.FTNMissing)
                return false
            }

            if self.certificateID == 0 {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.CertificateMissing)
                return false
            }

            if self.HomeAirportID == 0 {
                showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.LocationMissing)
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
    private func getParamsValues() -> [String: Any] {
        var params: [String: Any] =
        [
            kName : name,
            kemail : email,
            kRole : AppSelectedUserType.rawValue,
        ]
        
        if AppSelectedUserType == .Student {
            params[kCountryCode] = countryCode
            params[kMobile] = mobile
            params[kFTN] = FTN
            params[kCertificate_id] = certificateID
            params[kHome_airport_id] = HomeAirportID

        }else {
            params[kApprox_Hours] = approxHours
            params[kExperience_in_year] = experience_in_year
            params[kRate_per_hour] = ratePerHour
            params[kAirport_id] = airPortID
            params[kBack_story] = backStory
        }
            
        return params
    }
    
}

// MARK: - API Call
extension  ProfileViewModel {
        
    /// registerapi
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func WSGetProfileDetails(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        GeneralUtility().addButtonTapHaptic()
        
        let param : [String : Any] = [user_id : userID]

        ServiceManager.shared.postRequest(apiURL: .GetProfile, parameters: param, isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            self.profileModel = ModelProfileMain(fromJson: response["data"])

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

    
    func WSGetMyProfile(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        GeneralUtility().addButtonTapHaptic()
        
        let param : [String : Any] = [user_id : userID]

        ServiceManager.shared.getRequest(apiURL: .GetMyProfile, parameters: param, isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

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

    
    /// registerapi
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func WSEditProfile(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        let imgParams  = ServiceManager.multiPartDataType(fileData: profileImgData, keyName: kProfileImage)
        
        ServiceManager.shared.postMultipartRequest(apiURL: .EditProfile, imageVideoParameters: [imgParams], parameters: self.getParamsValues()) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
            AviationUser.shared.setData(dict: response["data"])
            self.profileModel = ModelProfileMain(fromJson: response["data"])

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
