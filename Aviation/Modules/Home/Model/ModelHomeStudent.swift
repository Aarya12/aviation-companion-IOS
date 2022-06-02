//
//	ModelHomeStudent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeStudent : NSObject, NSCoding{
    
    var certificates : ModelHomeCertificate!
    var email : String!
    var id : Int!
    var name : String!
    var profileImage : String!
    var totalNotes : Int!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let certificatesJson = json["certificates"]
        if !certificatesJson.isEmpty{
            certificates = ModelHomeCertificate(fromJson: certificatesJson)
        }
        email = json["email"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        profileImage = json["profile_image"].stringValue
        totalNotes = json["total_notes"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if certificates != nil{
            dictionary["certificates"] = certificates.toDictionary()
        }
        if email != nil{
            dictionary["email"] = email
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if profileImage != nil{
            dictionary["profile_image"] = profileImage
        }
        if totalNotes != nil{
            dictionary["total_notes"] = totalNotes
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         certificates = aDecoder.decodeObject(forKey: "certificates") as? ModelHomeCertificate
         email = aDecoder.decodeObject(forKey: "email") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         totalNotes = aDecoder.decodeObject(forKey: "total_notes") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if certificates != nil{
            aCoder.encode(certificates, forKey: "certificates")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if profileImage != nil{
            aCoder.encode(profileImage, forKey: "profile_image")
        }
        if totalNotes != nil{
            aCoder.encode(totalNotes, forKey: "total_notes")
        }

    }

}
