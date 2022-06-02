//
//  ServiceManager.swift
//  DemoServiceManage
//
//  Created by Zestbrains on 11/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import Toaster

typealias APIResponseBlock = ((_ response: JSON,_ isSuccess: Bool,_ error: String ,_ statusCode : Int?)->())
typealias APIResponseBlockWithStatusCode = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())
typealias APIFailureResponseBlock = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())


enum apiURL {
    case none
    case baseURL

    //Authentication
    case login
    case signup
    case forgotPassword
    case checkSocialAvaibilty
    case SocialRegister
    
    case GetAviations
    case GetCertificates
    
    //user
    case GetMyProfile
    case GetProfile
    case EditProfile
    case ChangePassword
    case LogOut
    case checkVersion
    case SwitchUserRole
    
    //Students List
    case allStudentsList
    case addStudent
    case addStudentViaEmail
    case myStudentsList
    
    //EVENT
    case addEditEvent
    case myEventsList
    case deleteEvent
    case getEventDetails
    
    //Instructor
    case myInstructorsList
    case allInstructorList
    case myNotes
    
    //Notes
    case getTagsList
    case CreateUpdateNote
    case DeleteNote
    case getNoteDetails
    case DownloadNoteAsPDF
    case GetMyStudentNote
    case myInstructorNotes
    
    //Home
    case GetHomeDetails
            
    func strURL() -> String {
        var str : String  = ""
        
        switch self {
        case .none :
            return ""
        case .baseURL:
            return "https://hexeros.com/dev/aviation/public/api/V1/"
            
        //Authentication
        case .login :
            str = "login"
        case .signup :
            str = "signup"
        case .forgotPassword :
            str = "forgot_password"
        case .checkSocialAvaibilty :
            str = "check_social_ability"
        case .SocialRegister :
            str = "social_register"
            
        case .GetAviations :
            str = "getAirportList"
        case .GetCertificates :
            str = "getCertificatesList"

        //user
        case .GetMyProfile :
            str = "user/getProfile"
        case .GetProfile :
            str = "user/getUserProfile"
        case .EditProfile :
            str = "user/edit_profile"
        case .ChangePassword :
            str = "user/updatePassword"
        case .LogOut :
            str = "user/logout"
        case .checkVersion:
            str = "version_checker"
        case .SwitchUserRole :
            str = "user/switchRole"
            
        //Students List
        case .allStudentsList :
            str = "instructor/allStudentsList"
        case .addStudent :
            str = "instructor/addStudent"
        case .addStudentViaEmail :
            str = "instructor/addStudentViaEmail"
        case .myStudentsList :
            str = "instructor/myStudentsList"

        //EVENT
        case .addEditEvent :
            str = "event/addEditEvent"
        case .myEventsList :
            str = "user/myEventsList"
        case .deleteEvent :
            str = "user/deleteEvent"
        case .getEventDetails :
            str = "user/eventDetail"
            
        //Instructor
        case .myInstructorsList :
            str = "student/myInstructorsList"
        case .allInstructorList :
            str = "student/allInstructorList"
        case .myNotes :
            str = "student/myNotes"

        //Notes
        case .getTagsList :
            str = "getTagsList"
        case .CreateUpdateNote :
            str = "instructor/addStudentNote"
        case .DeleteNote :
            str = "instructor/deleteStudentNote"
        case .getNoteDetails :
            str = "instructor/getNoteDetails"
        case .DownloadNoteAsPDF :
            str = "user/createNotePDF"
        case .GetMyStudentNote :
            str = "instructor/studentNotes"
        case .myInstructorNotes :
            str = "student/myInstructorNotes"

        //Home
        case .GetHomeDetails :
            str = "user/home"
        }
        
        return apiURL.baseURL.strURL() + str
    }
}


class ServiceManager: NSObject {
    
    static let shared : ServiceManager = ServiceManager()
    let manager: Session

    var headers: HTTPHeaders  {
        let header : HTTPHeaders = ["Authorization" : "Bearer" +  " " + AviationUser.shared.token ?? ""]
        return header
    }
    var paramEncode: ParameterEncoding = URLEncoding.default

    override init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60*2
        configuration.timeoutIntervalForResource = 60*2

        manager = Session(configuration: configuration)

        super.init()
    }


    //MARK:- API CAlling methods
    func postRequest(apiURL : apiURL , strURLAdd : String = "",
                     parameters : [String: Any] ,
                     isShowLoader : Bool = true,
                     isPassHeader : Bool = true,
                     additionalHeader : HTTPHeaders = [:],
                     isShowErrorAlerts : Bool = true,
                     Success successBlock:@escaping APIResponseBlock,
                     Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
                        
            var header : HTTPHeaders = additionalHeader
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {
                
                if isShowLoader {
                    DispatchQueue.main.async {
                        SHOW_CUSTOM_LOADER()
                    }
                }

                let url = try getFullUrl(relPath: apiURL.strURL() + strURLAdd)

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)

                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
                
                    DispatchQueue.main.async {
                        if isShowLoader {
                            HIDE_CUSTOM_LOADER()
                        }
                    }
                    
                    self.printSucess(json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0

                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                       
                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }

                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }

                })
            }

        }catch let error {
            self.jprint(items: error)
            HIDE_CUSTOM_LOADER()
        }
    }

    func postRequest1(apiURL : apiURL ,
                     parameters : [String: Any] ,
                     isShowLoader : Bool = true,
                     isPassHeader : Bool = true,
                     isShowErrorAlerts : Bool = true,
                     Success successBlock:@escaping APIResponseBlock,
                     Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {

                if isShowLoader {
                    SHOW_CUSTOM_LOADER()
                }

                let url = try getFullUrl(relPath: (apiURL.strURL()))

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)

                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseString { resObj in
                    
                    HIDE_CUSTOM_LOADER()
                    
                    self.printSucess(json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0

                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                       
                        self.handleSucess(json: json,isStringJSON : true, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }

                        self.handleFailure(json: "",isStringJSON : true, error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }

                }


            }

        }catch let error {
            self.jprint(items: error)
            HIDE_CUSTOM_LOADER()
        }
    }

    func getRequest(apiURL : apiURL , strAddInURL : String = "",
                    parameters : [String: Any] ,
                    isShowLoader : Bool = true,
                    isPassHeader : Bool = true,
                    isShowErrorAlerts : Bool = true,
                    Success successBlock:@escaping APIResponseBlock,
                    Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
                        
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {

                if isShowLoader {
                    SHOW_CUSTOM_LOADER()
                }

                let url = try getFullUrl(relPath: apiURL.strURL() + strAddInURL)

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)

                _ = manager.request(url, method: .get, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
                
                    HIDE_CUSTOM_LOADER()
                    
                    self.printSucess(json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0

                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                       
                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }

                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }

                })
            }

        }catch let error {
            self.jprint(items: error)
            HIDE_CUSTOM_LOADER()
        }
    }

    func putRequest(apiURL : apiURL ,
                    parameters : [String: Any] ,
                    isShowLoader : Bool = true,
                    isPassHeader : Bool = true,
                    isShowErrorAlerts : Bool = true,
                    Success successBlock:@escaping APIResponseBlock,
                    Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {
                if isShowLoader {
                    SHOW_CUSTOM_LOADER()
                }

                let url = try getFullUrl(relPath: apiURL.strURL())

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)

                _ = manager.request(url, method: .put, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
                
                    HIDE_CUSTOM_LOADER()
                    
                    self.printSucess(json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0

                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                       
                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }

                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }

                })
            }

        }catch let error {
            self.jprint(items: error)
            HIDE_CUSTOM_LOADER()
        }
    }

    struct multiPartDataType {
        var mimetype : String  = "image/png"
        var fileName : String  = "swift.png"
        var fileData : Data?
        var keyName : String = ""
    }

    func postMultipartRequest(apiURL : apiURL ,
                              imageVideoParameters : [multiPartDataType],
                    parameters : [String: Any] ,
                    isShowLoader : Bool = true,
                    isPassHeader : Bool = true,
                    isShowErrorAlerts : Bool = true,
                    Success successBlock:@escaping APIResponseBlock,
                    Failure failureBlock:@escaping APIResponseBlock) {
        
        do {
            
            var header : HTTPHeaders = []
            if isPassHeader {
                header = self.headers
            }
            
            if ServiceManager.checkInterNet() {
                if isShowLoader {
                    SHOW_CUSTOM_LOADER()
                }

                let url = try getFullUrl(relPath: apiURL.strURL())

                
                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.headers = header

                //printing headers and parametes
                printStart(header: header ,Parameter: parameters , url: url)
                
                _ = manager.upload(multipartFormData: { multiPart in
                    for (key, value) in parameters {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key )
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                print("keyObj:",keyObj)
                                if let string = element as? String {
                                    print("string:",string)
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    print("num:",num)
                                    
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }else if let temp = value as? Double {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                        }

                    }
                    
                    for obj in imageVideoParameters {
                        if let fileData = obj.fileData {
                            multiPart.append(fileData, withName:obj.keyName, fileName: obj.fileName, mimeType: obj.mimetype)
                        }
                    }
                    
                }, with: urlRequest)
                
                .uploadProgress(queue: .main, closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                    .responseJSON(completionHandler: { (resObj) in
                
                    HIDE_CUSTOM_LOADER()
                    
                    self.printSucess(json: resObj)

                    let statusCode = resObj.response?.statusCode ?? 0

                    switch resObj.result {
                    case .success(let json) :
                        print("SuccessJSON \(json)")
                       
                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    
                    case .failure(let err) :
                        print(err)
                        
                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }

                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
                    }

                })
            }

        }catch let error {
            self.jprint(items: error)
            HIDE_CUSTOM_LOADER()
        }
    }

}


// MARK: - Internet Availability

extension ServiceManager {
    
    class func checkInterNet() -> Bool {
        if Connectivity.isConnectedToInternet() {
            return true
            
        }else {
            
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "Constant.APP_NAME", message: "Internet Connection seems to be offline", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
            return false
        }
    }
    
    //Get Full URL
    func getFullUrl(relPath : String) throws -> URL{
        do{
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www"){
                return try relPath.asURL()
            }else{
                return try (apiURL.baseURL.strURL() + relPath).asURL()
            }
        }catch let err{
            HIDE_CUSTOM_LOADER()
            throw err
        }
    }
}

//MARK:- Handler functions
extension ServiceManager {
        
    
    func handleSucess(json : Any,isStringJSON : Bool = false, statusCode : Int, isShowErrorAlerts : Bool = true, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
        
        DispatchQueue.main.async {

        var jsonResponse = JSON(json)
        if isStringJSON {
            jsonResponse = JSON.init(parseJSON: "\(json)")
        }
        let dataResponce:Dictionary<String,Any> = jsonResponse.dictionaryValue
        let errorMessage : String = jsonResponse["message"].string ?? "Something went wrong."
        
        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage.localizedCaseInsensitiveContains("no record found")))
        
        if(statusCode == 307)
        {
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            guard isShowErrorAlerts else { return }
            
            if let LIveURL:String = dataResponce["iOS_live_application_url"] as? String{
                if let topController = UIApplication.topViewController() {
                    
                    showAlertWithTitleFromVC(vc: topController, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Open Store"]) { (i) in
                        if let url = URL(string: LIveURL),
                           UIApplication.shared.canOpenURL(url){
                            guard let url = URL(string: "\(url)"), !url.absoluteString.isEmpty else {
                                return
                            }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
        else if(statusCode == 401)
        {
            AviationUser.shared.clear()
            
            failureBlock(jsonResponse,false,"Something went wrong.", statusCode)
            
            guard isShowErrorAlerts else { return }

                if let topController = UIApplication.topViewController() {
                    showAlertWithTitleFromVC(vc: topController, title: Constant.APP_NAME , andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                        appDelegate.setLoginScreen()
                    }
                }
            
        }
        else if (statusCode == 412){
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            guard isShowErrorAlerts else { return }

            if  errorMessage.lowercased() != "you need to register".lowercased() {
                
                if let topController = UIApplication.topViewController() {
                    showAlertWithTitleFromVC(vc: topController, andMessage: errorMessage)
                }
            }
        }
        
        else if (statusCode == 200){
            successBlock(jsonResponse, true, errorMessage,statusCode)
        }
        
        else{
            failureBlock(jsonResponse,false,errorMessage, statusCode)

            guard isShowErrorAlerts else { return }
            if let topController = UIApplication.topViewController() {
                showAlertWithTitleFromVC(vc: topController, andMessage: errorMessage)
            }
        }
        }
    }
    
    func handleFailure(json : Any, isStringJSON : Bool = false, error : AFError, statusCode : Int, isShowErrorAlerts : Bool = true, Success suceessBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
        
        DispatchQueue.main.async {

        var jsonResponse = JSON(json)
        if isStringJSON {
            jsonResponse = JSON.init(parseJSON: "\(json)")
        }

        let errorMessage : String = jsonResponse["message"].string ?? "Something went wrong."
        
        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage.localizedCaseInsensitiveContains("no record found")))

        print(error.localizedDescription)
        print("\n\n===========Error===========")
        print("Error Code: \(error._code)")
        print("Error Messsage: \(error.localizedDescription)")
        
        debugPrint(error as Any)
        print("===========================\n\n")
        HIDE_CUSTOM_LOADER()
        
        
        if (error._code == NSURLErrorTimedOut || error._code == 13 ) {
            failureBlock(jsonResponse,true,errorMessage, statusCode)
        }
        else{
            failureBlock(jsonResponse,false,errorMessage, statusCode)
            
            //showing alert
            guard isShowErrorAlerts else { return }
            
            if let topVC = UIApplication.topViewController() {
                showAlertWithTitleFromVC(vc: topVC, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["OK"]) { (tag) in
                    
                    if tag == 0 {
                        
                    }
                }
            }
        }
        }
    }
    
    func printStart(header : HTTPHeaders,Parameter: [String : Any] , url: URL)  {
        print("**** API CAll Start ****")
        print("**** API URL ****" , url)

        print("**** API Header Start ****")
        print(header)
        print("**** API Header End ****")
        print("**** API Parameter Start ****")
        print(Parameter)
        print("**** API Parameter End ****")
    }
    
    func printSucess(json : Any) {
        print("**** API CAll END ****")
        print("**** API Response Start ****")
        print(json)
        print("**** API Response End ****")
    }

    func jprint(items: Any...) {
        for item in items {
            print(item)
        }
    }

}


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


func downloadDocument(strFile : String , strFileName : String){
    
    let url = URL(string: strFile)
    let fileName = String((url!.lastPathComponent)) as NSString
    // Create destination URL
    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destinationFileUrl = documentsUrl.appendingPathComponent("\(strFileName)")
    //Create URL to the source file you want to download
    let fileURL = URL(string: strFile)
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let request = URLRequest(url:fileURL!)
    
    DispatchQueue.main.async {
        let toast = Toast(text: "File Downloading...")
        toast.show()
    }
    
    SHOW_CUSTOM_LOADER()
    
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
            
           // HIDE_CUSTOM_LOADER()
            
            // Success
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                DispatchQueue.main.async {
                    let toastDownloaded = Toast(text: "File Downloaded")
                    toastDownloaded.show()
                }

                print("Successfully downloaded. Status code: \(statusCode)")
            }
            do {
                try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                do {
                    
                    //Show UIActivityViewController to save the downloaded file
                    let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for indexx in 0..<contents.count {
                        if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                            let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                            DispatchQueue.main.async {
                        HIDE_CUSTOM_LOADER()
                                UIApplication.topViewController()?.present(activityViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                catch (let err) {
                    HIDE_CUSTOM_LOADER()
                    print("error: \(err)")
                    showAlertWithTitleFromVC(vc: UIApplication.topViewController()!, andMessage: "Error : \(err.localizedDescription)")
                }
            } catch (let writeError) {
                HIDE_CUSTOM_LOADER()
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
                showAlertWithTitleFromVC(vc: UIApplication.topViewController()!, andMessage: "Error creating a file \(destinationFileUrl) : \(writeError)")
            }
        } else {
            HIDE_CUSTOM_LOADER()
            print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
        }
    }
    task.resume()

    
}
