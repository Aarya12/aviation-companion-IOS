//
//  StudentNotesViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 06/01/22.
//

import Foundation
import UIKit
import SwiftyJSON

class StudentNotesViewModel {
    
    var arrNotes : [ModelStudentNotes] = [] {
        didSet {
            self.offset = arrNotes.count
        }
    }
    var offset : Int = 0
    var hasMoreData : Bool = false
    var limit : Int = 10
    var strSearch : String = ""
    var studentID : Int = 0
    
    var notesModel : ModelStudentNotes!
    
    /// getStudentNotes
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getStudentNotes(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        var params : [String : Any] = [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit]
        
        var api : apiURL = .GetMyStudentNote
        
        if AppSelectedUserType == .Instructor {
            params["student_id"] = self.studentID
            api = .GetMyStudentNote
        }else {
            params["instructor_id"] = self.studentID
            api = .myInstructorNotes
        }
        
        ServiceManager.shared.postRequest(apiURL: api, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrNotes.removeAll()
            }

            if isSuccess == true {
                
                var arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                if AppSelectedUserType == .Student {
                    arr = response["data"].arrayValue
                }else {
                    arr = response["data"].arrayValue
                }

                arr.forEach { obj in
                    self.arrNotes.append(ModelStudentNotes(fromJson: obj))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrNotes.removeAll()
            failure(response)
        }
    }

    /// getStudentNotes
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getAllNotes(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        var params : [String : Any] = [kSearch : strSearch , kOffset : self.offset , kLimit : self.limit]
        
        
        ServiceManager.shared.postRequest(apiURL: .myNotes, parameters:  [:] , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if self.offset == 0 {
                self.arrNotes.removeAll()
            }

            if isSuccess == true {
                
                let arr = response["data"].arrayValue
                self.hasMoreData = !(arr.count < self.limit)
                 
                arr.forEach { obj in
                    self.arrNotes.append(ModelStudentNotes(fromJson: obj))
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            self.hasMoreData = false
            self.arrNotes.removeAll()
            failure(response)
        }
    }

    /// getNoteDetails
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getNoteDetails(id : String ,isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let params : [String : Any] = ["note_id" : id]
        
        ServiceManager.shared.postRequest(apiURL: .getNoteDetails, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if isSuccess == true {
                
                self.notesModel = ModelStudentNotes(fromJson: response["data"])

                success(response)
                
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }

    
    /// deleteNote
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func deleteNote(id : String ,isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let params : [String : Any] = ["note_id" : id]
        
        ServiceManager.shared.postRequest(apiURL: .DeleteNote, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if isSuccess == true {
                
                self.notesModel = ModelStudentNotes(fromJson: response["data"])

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
