//
//  StudentsViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 30/12/21.
//

import Foundation
import UIKit
import SwiftyJSON
import Toaster

class StudentsViewModel  {
 
    var arrStudents : [ModelStudents] = [] {
        didSet {
            self.offset = arrStudents.count
        }
    }
    var offset : Int = 0
    var hasMoreData : Bool = false
    var limit : Int = 10
    
}

//MARK: - WEBSERVICE CALLS
extension  StudentsViewModel {
    
    /// getAllStudents
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getAllStudents(strSearch : String , isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        ServiceManager.shared.postRequest(apiURL: .allStudentsList, parameters: [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit] , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrStudents.removeAll()
            }

            if isSuccess == true {
                
                let arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                arr.forEach { obj in
                    self.arrStudents.append(ModelStudents(fromJson: obj))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrStudents.removeAll()
            failure(response)
        }
    }

    /// getMyStudents
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getMyStudents(strSearch : String , isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        ServiceManager.shared.postRequest(apiURL: .myStudentsList, parameters: [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit] , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrStudents.removeAll()
            }

            if isSuccess == true {
                
                let arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                arr.forEach { obj in
                    self.arrStudents.append(ModelStudents(fromJson: obj["students"]))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrStudents.removeAll()
            failure(response)
        }
    }

    
    /// addStudent
    ///
    /// - Parameters:
    ///   - id: id of the student
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func addStudent(id : Int , isShowLoader : Bool = false, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        ServiceManager.shared.postRequest(apiURL: .addStudent, parameters: [kStudent_id : id] , isShowLoader : isShowLoader) { response, isSuccess, message, statusCode in

            print("Success Response:", response)

            if isSuccess == true {
                
                Toast(text: message).show()

                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }

    
    //MARK: - INSTRUCTOR
    func getMyInstructors(strSearch : String , isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        ServiceManager.shared.postRequest(apiURL: .myInstructorsList, parameters: [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit] , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrStudents.removeAll()
            }

            if isSuccess == true {
                
                let arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                arr.forEach { obj in
                    self.arrStudents.append(ModelStudents(fromJson: obj["instructor"]))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrStudents.removeAll()
            failure(response)
        }
    }

}
