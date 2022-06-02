//
//  CreateEventViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 05/01/22.
//

import Foundation
import UIKit
import SwiftyJSON

class CreateEventViewModel {
    
    var vc: UIViewController?
    
    var eventID : Int = 0
    var arrStudentsIds : [Int] = []
    var strDateTime : String = ""
    var strAgenda : String = ""
    var strDescription : String = ""
    var locationID : Int = 0
    var countryCode : String = ""
    var mobile : String = ""
    var arrEmails : [String] = []
    
    private func isValidate(isSocialRegister : Bool = false) -> Bool {
        
        guard let vc = self.vc else {
            return false
        }

        if self.arrStudentsIds.isEmpty || self.arrStudentsIds.count == 0 {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.StudentUnselected)
            return false
        }

        if self.strDateTime.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.dateTimeMissing)
            return false
        }

        if self.strAgenda.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.AgendaMissing)
            return false
        }
        
        if self.strDescription.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.DescriptionMissing)
            return false
        }

        if self.locationID == 0 {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.EventLocationMissing)
            return false
        }

        if self.mobile.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.MobileMissing)
            return false
        }

        if self.arrEmails.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.EventEmailsMissing)
            return false
        }

        return true
    }
    
    /// returns the parameters for the register
    private func getParamsValues() -> [String: Any] {
        
        var params: [String: Any] =
        [
            kDatetime : getStrDateFromDate(date: strDateTime, fromFormat: "dd MMM yyyy hh:mm a", toFormat: "yyyy-MM-dd HH:mm"),
            kAgenda : strAgenda,
            kDescription : strDescription,
            kLocation : locationID,
            kCountryCode : countryCode,
            kMobile : mobile
        ]
        
        for i in 0..<arrStudentsIds.count {
            params["students[\(i)]"] = arrStudentsIds[i]
        }
        
        //adding email paramters
        for i in 0..<arrEmails.count {
            params["emails[\(i)]"] = arrEmails[i]
        }
        
        if eventID != 0 {
            params["event_id"] = eventID
        }
        
        return params
    }
    
}

// MARK: - API Call
extension  CreateEventViewModel {
        
    /// AddEditEventAPI
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func AddEditEventAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .addEditEvent, parameters: self.getParamsValues()) { response, isSuccess, error, statusCode in

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

    
    /// deleteEventAPI
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func deleteEventAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .deleteEvent, parameters: self.getParamsValues()) { response, isSuccess, error, statusCode in

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
