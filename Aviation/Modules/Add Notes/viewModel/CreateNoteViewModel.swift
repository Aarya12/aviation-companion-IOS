//
//  CreateNoteViewModel.swift
//  Aviation
//
//  Created by Zestbrains on 24/01/22.
//

import Foundation
import UIKit
import SwiftyJSON

class CreateNoteViewModel {
    
    var vc: UIViewController?

    var studentID : Int = 0
    var strNoteDateTime : String = ""
    var strTotalTime : String = ""
    var noteID : Int = 0
    var strNote : String = ""
    var strPrivateNote : String = ""
    var arrTags : [String] = []
    
    
    private func isValidate() -> Bool {
        
        guard let vc = self.vc else {
            return false
        }

        if self.strNoteDateTime.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.noteDateTimeMissing)
            return false
        }

        if self.strTotalTime.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.noteTotalTimeMissing)
            return false
        }

        if self.arrTags.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.noteTags)
            return false
        }

        if self.strNote.isEmpty {
            showAlertWithTitleFromVC(vc: vc, andMessage: AlertMessage.noteMissign)
            return false
        }
        
        return true
    }

    /// returns the parameters for the register
    private func getParamsValues() -> [String: Any] {
        
        let strTags : String = self.arrTags.joined(separator: ",")
        
        var params: [String: Any] =
        [
            kStudent_id : studentID,
            kDatetime : getStrDateFromDate(date: strNoteDateTime, fromFormat: "dd MMM yyyy hh:mm a", toFormat: "yyyy-MM-dd HH:mm"),
            "total_hours" : self.strTotalTime,
            "note" : self.strNote,
            "tags" : strTags,
            "private_note" : self.strPrivateNote
        ]
        
        if noteID != 0 {
            params["note_id"] = self.noteID
        }
        
        return params
    }

}


//MARK: - API calls
extension CreateNoteViewModel {

    /// getTags
    ///
    /// - Parameters:
    ///   - strSearch: search keywords of the map
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func getTags(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
                        
        let params : [String : Any] = ["keywords" : strNote , kLimit : 10000, kOffset : 0]
        
        ServiceManager.shared.postRequest(apiURL: .getTagsList, parameters:  params , isShowLoader : isShowLoader) { response, isSuccess, error, statusCode in

            print("Success Response:", response)

            if isSuccess == true {
                
                var arr = response["data"].arrayValue
                
                arr.forEach { obj in
                    if !self.arrTags.contains(obj.stringValue) {
                        self.arrTags.append(obj.stringValue)
                    }
                }
                
                success(response)
            } else {
                failure(response)
            }

        } Failure: { response, isSuccess, error, statusCode in
            print("Failure Response:", response)
            failure(response)
        }
    }

    /// AddEditNoteAPI
    ///
    /// - Parameters:
    ///   - success: return block success - empty
    ///   - failure: return block failure - response dic
    func AddEditNoteAPI(isShowLoader : Bool = true, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: JSON) -> Void) {
        
        if self.isValidate() ==  false {
            return
        }
        
        GeneralUtility().addButtonTapHaptic()
        
        ServiceManager.shared.postRequest(apiURL: .CreateUpdateNote, parameters: self.getParamsValues()) { response, isSuccess, error, statusCode in

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
