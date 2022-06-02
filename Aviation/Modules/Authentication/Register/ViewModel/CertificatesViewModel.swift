//
//  CertificatesViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 04/01/22.
//

import Foundation
import UIKit
import SwiftyJSON

class CertificatesViewModel {
    
    init() {
        self.getCertificates { response in
            //response
        } failure: { err in
            //err
        }

    }
    static let shared = CertificatesViewModel()

    var arrCertificates : [ModelProfileAirport] = []

    
    /// getCertificates
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getCertificates(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                
        GeneralUtility().addButtonTapHaptic()
                
        ServiceManager.shared.postRequest(apiURL: .GetCertificates, parameters: [:]) { response, isSuccess, error, statusCode in

            self.arrCertificates = response["data"].arrayValue.map({ModelProfileAirport(fromJson: $0)})
            
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
