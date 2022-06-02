//
//	ModelEventEmails.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelEventEmails : NSObject, NSCoding{

	var email : String!
	var eventId : Int!
	var id : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		email = json["email"].stringValue
		eventId = json["event_id"].intValue
		id = json["id"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if email != nil{
			dictionary["email"] = email
		}
		if eventId != nil{
			dictionary["event_id"] = eventId
		}
		if id != nil{
			dictionary["id"] = id
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         email = aDecoder.decodeObject(forKey: "email") as? String
         eventId = aDecoder.decodeObject(forKey: "event_id") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if eventId != nil{
			aCoder.encode(eventId, forKey: "event_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}

	}

}