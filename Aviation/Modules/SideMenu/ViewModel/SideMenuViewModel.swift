//
//  SideMenuViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 23/12/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SideMenuViewModel {
    
    var vc: UIViewController?

    var newRole : userType = AppSelectedUserType
    
    // MARK: - API Call

    /// WSSwitchUserRole
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func WSSwitchUserRole(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        let params = [kNew_role : newRole.rawValue]
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .SwitchUserRole, parameters: params) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
                        
            if isSuccess == true {
                AppSelectedUserType = self.newRole
                
                AviationUser.shared.type = AppSelectedUserType.rawValue
                AviationUser.shared.save()

                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }
    

    func WSLogout(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.getRequest(apiURL: .LogOut, parameters: [:]) { (response, Success, message, statusCode) in
            
            print("Success Response:", response)

            if Success == true{
                AviationUser.shared.clear()
                
                success(response)
            }else {
                failure(response)
            }
            
            print("Success Response:",response)
        } Failure: { (response, Success, message, statusCode) in
            print("Failure Response:",response)
            failure(response)
        }
    }


}
