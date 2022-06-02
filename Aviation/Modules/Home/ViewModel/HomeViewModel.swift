//
//  HomeViewModel.swift
//  Aviation
//

import Foundation
import UIKit
import SwiftyJSON

class HomeViewModel {
    
    var vc: UIViewController?

    var homeModel : ModelHomeMain!

    // MARK: - API Call

    /// getHomeDetails
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getHomeDetails(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .GetHomeDetails, parameters: [:]) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
                        
            if isSuccess == true {
                self.homeModel = ModelHomeMain(fromJson: response["data"])
                
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
