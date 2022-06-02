//
//	ModelHomeMain.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeMain : NSObject, NSCoding{

	var events : [ModelHomeEvent]!
	var users : [ModelHomeUser]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		events = [ModelHomeEvent]()
		var eventsArray = json["events"].arrayValue
        if AppSelectedUserType == .Student {
            eventsArray = json["events"].arrayValue.map({$0["event_detail"]})
        }else {
            eventsArray = json["events"].arrayValue
        }

		for eventsJson in eventsArray{
			let value = ModelHomeEvent(fromJson: eventsJson)
			events.append(value)
		}
        
		users = [ModelHomeUser]()
		let usersArray = json["users"].arrayValue
		for usersJson in usersArray{
			let value = ModelHomeUser(fromJson: usersJson)
			users.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if events != nil{
			var dictionaryElements = [[String:Any]]()
			for eventsElement in events {
				dictionaryElements.append(eventsElement.toDictionary())
			}
			dictionary["events"] = dictionaryElements
		}
		if users != nil{
			var dictionaryElements = [[String:Any]]()
			for usersElement in users {
				dictionaryElements.append(usersElement.toDictionary())
			}
			dictionary["users"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         events = aDecoder.decodeObject(forKey: "events") as? [ModelHomeEvent]
         users = aDecoder.decodeObject(forKey: "users") as? [ModelHomeUser]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if events != nil{
			aCoder.encode(events, forKey: "events")
		}
		if users != nil{
			aCoder.encode(users, forKey: "users")
		}

	}

}
