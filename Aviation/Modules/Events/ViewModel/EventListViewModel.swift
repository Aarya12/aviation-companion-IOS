//
//  EventListViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 06/01/22.
//

import Foundation
import UIKit
import SwiftyJSON

class EventListViewModel {
    
    var arrEvents : [ModelEventsMain] = [] {
        didSet {
            self.offset = arrEvents.count
        }
    }
    var offset : Int = 0
    var hasMoreData : Bool = false
    var limit : Int = 10
    var type : String = "upcoming"
    var strSearch : String = ""
    
    var eventModel : ModelEventsMain!
    
    /// getMyEvents
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getMyEvents(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let params : [String : Any] = [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit , kType : self.type]
        
        ServiceManager.shared.postRequest(apiURL: .myEventsList, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrEvents.removeAll()
            }

            if isSuccess == true {
                
                var arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                if AppSelectedUserType == .Student {
                    arr = response["data"].arrayValue.map({$0["event_detail"]})
                }else {
                    arr = response["data"].arrayValue
                }

                arr.forEach { obj in
                    self.arrEvents.append(ModelEventsMain(fromJson: obj))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrEvents.removeAll()
            failure(response)
        }
    }

    /// getEventDetails
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getEventDetails(id : String ,isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let params : [String : Any] = ["event_id" : id]
        
        ServiceManager.shared.postRequest(apiURL: .getEventDetails, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if isSuccess == true {
                
                self.eventModel = ModelEventsMain(fromJson: response["data"])

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
