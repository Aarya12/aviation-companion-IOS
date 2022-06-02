//
//  AviationsViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 04/01/22.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreLocation

class AviationsViewModel {
            
    init() { }
    
    static let shared = AviationsViewModel()
    
    var arrAviations : [ModelProfileAirport] = []
    var offset : Int = 0
    let limit : Int = 100
    var hasMoreData : Bool = true

    
    /// getAviations
    ///
    /// - Parameters:
    ///   - keywords: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getAviations(keywords : String , isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        ServiceManager.shared.postRequest(apiURL: .GetAviations, parameters: [kKeyWords : keywords , kLimit : limit, kOffset : offset], isShowLoader: isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)
            if self.offset == 0 {
                self.arrAviations.removeAll()
            }
            let arr = response["data"].arrayValue
            
            arr.forEach { obj in
                self.arrAviations.append(ModelProfileAirport(fromJson: obj))
            }
            
            self.hasMoreData = (arr.count >= self.limit)

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

    
    func getNearByAirports(_ vc : UIViewController , NearByAirports : @escaping (([ModelProfileAirport]) -> Void)){
        
        LocationManager.shared.getLocation(vc: vc) { location, error in
            
            let arr = self.arrAviations.sorted { obj1, obj2 in
                let loc1 = CLLocation(latitude: (obj1.lat ?? "").doubleValue, longitude: (obj1.lng ?? "").doubleValue)
                
                let loc2 = CLLocation(latitude: (obj2.lat ?? "").doubleValue, longitude: (obj2.lng ?? "").doubleValue)
                
                return (location?.distance(from: loc1) ?? 0) < (location?.distance(from: loc2) ?? 0)
            }
            
            let maximumNearbyShowing : Int = 5
            let finalArr = Array(arr[0..<maximumNearbyShowing])
            NearByAirports(finalArr)
        }
    }
}
