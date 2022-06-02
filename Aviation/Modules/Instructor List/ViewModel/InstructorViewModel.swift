//
//  InstructorViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 17/01/22.
//

import Foundation
import UIKit
import SwiftyJSON
import Toaster

class InstructorViewModel  {
 
    var arrInstructors : [ModelInstructorMain] = [] {
        didSet {
            self.offset = arrInstructors.count
        }
    }
    var offset : Int = 0
    var hasMoreData : Bool = false
    var limit : Int = 10
    
    var strSearch : String = ""
    var experience : String = ""
    var price : String = ""
    var latitude : Double = 0
    var longitude : Double = 0
}

//MARK: - WEBSERVICE CALLS
extension  InstructorViewModel {
    
    /// getAllStudents
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getAllInstructor(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let param : [String : Any] = [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit, "experience" : experience , "price" : price , "latitude" : self.latitude , "longitude" : longitude]
        
        ServiceManager.shared.postRequest(apiURL: .allInstructorList, parameters: param , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrInstructors.removeAll()
            }

            if isSuccess == true {
                
                let arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                arr.forEach { obj in
                    self.arrInstructors.append(ModelInstructorMain(fromJson: obj))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrInstructors.removeAll()
            failure(response)
        }
    }

}
