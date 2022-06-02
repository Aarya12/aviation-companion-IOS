//
//  AviationUser.swift
//  Aviation
//
//  Created by Mac on 21/12/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import SwiftyJSON

class AviationUser: NSObject  ,NSCoding {
    
    var airportData         : ModelProfileAirport!
    var airportId           : Int!
    var approxHours         : String!
    var backStory           : String!
    var certificateId       : Int!
    var certificatesData    : ModelProfileAirport!
    var countryCode         : String!
    var email               : String!
    var experienceInYear    : Int!
    var ftn                 : String!
    var id                  : String    = ""
    var mobile              : String!
    var name                : String    = ""
    var profileImage        : String    = ""
    var ratePerHour         : Int!
    var token               : String    = ""
    var totalHours          : String!
    var totalNotes          : Int!
    var type                : String = "" {
        didSet {
            AppSelectedUserType = userType(rawValue: type) ?? .Student
        }
    }
    
    
    var preference = [NSDictionary]()
    static var shared: AviationUser = AviationUser()
    
    
    override init()
    {
        super.init()
        let encodedObject:NSData? = UserDefaults.standard.object(forKey: "AviationUSER") as? NSData
        if encodedObject != nil
        {
            let userDefaultsReference = UserDefaults.standard
            let encodedeObject:NSData = userDefaultsReference.object(forKey: "AviationUSER") as! NSData
            let kUSerObject:AviationUser = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! AviationUser
            self.loadContent(fromUser: kUSerObject);
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        airportData = aDecoder.decodeObject(forKey: "airport_data") as? ModelProfileAirport
        airportId = aDecoder.decodeObject(forKey: "airport_id") as? Int
        approxHours = aDecoder.decodeObject(forKey: "approx_hours") as? String
        backStory = aDecoder.decodeObject(forKey: "back_story") as? String
        certificateId = aDecoder.decodeObject(forKey: "certificate_id") as? Int
        certificatesData = aDecoder.decodeObject(forKey: "certificates_data") as? ModelProfileAirport
        countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        experienceInYear = aDecoder.decodeObject(forKey: "experience_in_year") as? Int
        ftn = aDecoder.decodeObject(forKey: "ftn") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String ?? ""
        ratePerHour = aDecoder.decodeObject(forKey: "rate_per_hour") as? Int
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        totalHours = aDecoder.decodeObject(forKey: "total_hours") as? String
        totalNotes = aDecoder.decodeObject(forKey: "total_notes") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
    }
    
    func loadUser() -> AviationUser
    {
        let userDefaultsReference = UserDefaults.standard
        let encodedeObject:NSData = userDefaultsReference.object(forKey: "AviationUSER") as! NSData
        let kUSerObject:AviationUser = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! AviationUser
        return kUSerObject
    }
    
    
    func encode(with aCoder: NSCoder) {
        if airportData != nil{
            aCoder.encode(airportData, forKey: "airport_data")
        }
        if airportId != nil{
            aCoder.encode(airportId, forKey: "airport_id")
        }
        if approxHours != nil{
            aCoder.encode(approxHours, forKey: "approx_hours")
        }
        if backStory != nil{
            aCoder.encode(backStory, forKey: "back_story")
        }
        if certificateId != nil{
            aCoder.encode(certificateId, forKey: "certificate_id")
        }
        if certificatesData != nil{
            aCoder.encode(certificatesData, forKey: "certificates_data")
        }
        if countryCode != nil{
            aCoder.encode(countryCode, forKey: "country_code")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if experienceInYear != nil{
            aCoder.encode(experienceInYear, forKey: "experience_in_year")
        }
        if ftn != nil{
            aCoder.encode(ftn, forKey: "ftn")
        }
        aCoder.encode(id, forKey: "id")
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        aCoder.encode(name, forKey: "name")
        aCoder.encode(profileImage, forKey: "profile_image")
        if ratePerHour != nil{
            aCoder.encode(ratePerHour, forKey: "rate_per_hour")
        }
        aCoder.encode(token, forKey: "token")
        if totalHours != nil{
            aCoder.encode(totalHours, forKey: "total_hours")
        }
        if totalNotes != nil{
            aCoder.encode(totalNotes, forKey: "total_notes")
        }
        aCoder.encode(type, forKey: "type")
    }
    
    private func loadContent(fromUser user:AviationUser) -> Void    {
        self.airportData = user.airportData
        self.airportId = user.airportId
        self.approxHours = user.approxHours
        self.backStory = user.backStory
        self.certificateId = user.certificateId
        self.certificatesData = user.certificatesData
        self.countryCode = user.countryCode
        self.email = user.email
        self.experienceInYear = user.experienceInYear
        self.ftn = user.ftn
        self.id = user.id
        self.mobile = user.mobile
        self.name = user.name
        self.profileImage = user.profileImage
        self.ratePerHour = user.ratePerHour
        self.token = user.token
        self.totalHours = user.totalHours
        self.totalNotes = user.totalNotes
        self.type = user.type
        
    }
    
    func save() -> Void    {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(encodedObject, forKey: "AviationUSER")
        UserDefaults.standard.synchronize()
    }
    
    func clear() -> Void
    {
        self.airportData         = nil
        self.airportId           = nil
        self.approxHours         = nil
        self.backStory           = nil
        self.certificateId       = nil
        self.certificatesData    = nil
        self.countryCode         = nil
        self.email               = nil
        self.experienceInYear    = nil
        self.ftn                 = nil
        self.id                  = ""
        self.mobile              = nil
        self.name                = ""
        self.profileImage        = ""
        self.ratePerHour         = nil
        self.token               = ""
        self.totalHours          = nil
        self.totalNotes          = nil
        self.type                = ""
        
        AviationUser.shared.save()
        
        //remove all user data from app
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    func setData(dict:JSON) -> Void {
        
        let json = dict
        if json.isEmpty{
            return
        }
        
        let airportDataJson = json["airport_data"]
        if !airportDataJson.isEmpty{
            airportData = ModelProfileAirport(fromJson: airportDataJson)
        }
        airportId = json["airport_id"].intValue
        approxHours = json["approx_hours"].stringValue
        backStory = json["back_story"].stringValue
        certificateId = json["certificate_id"].intValue
        let certificatesDataJson = json["certificates_data"]
        if !certificatesDataJson.isEmpty{
            certificatesData = ModelProfileAirport(fromJson: certificatesDataJson)
        }
        countryCode = json["country_code"].stringValue
        email = json["email"].stringValue
        experienceInYear = json["experience_in_year"].intValue
        ftn = json["ftn"].stringValue
        id = json["id"].stringValue
        mobile = json["mobile"].stringValue
        name = json["name"].stringValue
        profileImage = json["profile_image"].stringValue
        ratePerHour = json["rate_per_hour"].intValue
        token = json["token"].stringValue
        totalHours = json["total_hours"].stringValue
        totalNotes = json["total_notes"].intValue
        type = json["type"].stringValue
        
        AviationUser.shared.save()
    }
    
    func setPrefranceData(dict:[NSDictionary]) -> Void {
        AviationUser.shared.preference = dict
        AviationUser.shared.save()
    }
}

