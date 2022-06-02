//
//	ModelHomeEvent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeEvent : NSObject, NSCoding{

	var agenda : String!
	var countryCode : String!
	var countryName : String!
	var datetime : String!
	var descriptionField : String!
	var id : Int!
	var instructorId : Int!
	var joinedStudents : [ModelHomeJoinedStudent]!
	var latitude : String!
	var location : ModelHomeLocation!
	var longitude : String!
	var mobile : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		agenda = json["agenda"].stringValue
		countryCode = json["country_code"].stringValue
		countryName = json["country_name"].stringValue
		datetime = json["datetime"].stringValue
		descriptionField = json["description"].stringValue
		id = json["id"].intValue
		instructorId = json["instructor_id"].intValue
		joinedStudents = [ModelHomeJoinedStudent]()
		let joinedStudentsArray = json["joined_students"].arrayValue
		for joinedStudentsJson in joinedStudentsArray{
			let value = ModelHomeJoinedStudent(fromJson: joinedStudentsJson)
			joinedStudents.append(value)
		}
		latitude = json["latitude"].stringValue
		let locationJson = json["location"]
		if !locationJson.isEmpty{
			location = ModelHomeLocation(fromJson: locationJson)
		}
		longitude = json["longitude"].stringValue
		mobile = json["mobile"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if agenda != nil{
			dictionary["agenda"] = agenda
		}
		if countryCode != nil{
			dictionary["country_code"] = countryCode
		}
		if countryName != nil{
			dictionary["country_name"] = countryName
		}
		if datetime != nil{
			dictionary["datetime"] = datetime
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if id != nil{
			dictionary["id"] = id
		}
		if instructorId != nil{
			dictionary["instructor_id"] = instructorId
		}
		if joinedStudents != nil{
			var dictionaryElements = [[String:Any]]()
			for joinedStudentsElement in joinedStudents {
				dictionaryElements.append(joinedStudentsElement.toDictionary())
			}
			dictionary["joined_students"] = dictionaryElements
		}
		if latitude != nil{
			dictionary["latitude"] = latitude
		}
		if location != nil{
			dictionary["location"] = location.toDictionary()
		}
		if longitude != nil{
			dictionary["longitude"] = longitude
		}
		if mobile != nil{
			dictionary["mobile"] = mobile
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         agenda = aDecoder.decodeObject(forKey: "agenda") as? String
         countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
         countryName = aDecoder.decodeObject(forKey: "country_name") as? String
         datetime = aDecoder.decodeObject(forKey: "datetime") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         instructorId = aDecoder.decodeObject(forKey: "instructor_id") as? Int
         joinedStudents = aDecoder.decodeObject(forKey: "joined_students") as? [ModelHomeJoinedStudent]
         latitude = aDecoder.decodeObject(forKey: "latitude") as? String
         location = aDecoder.decodeObject(forKey: "location") as? ModelHomeLocation
         longitude = aDecoder.decodeObject(forKey: "longitude") as? String
         mobile = aDecoder.decodeObject(forKey: "mobile") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if agenda != nil{
			aCoder.encode(agenda, forKey: "agenda")
		}
		if countryCode != nil{
			aCoder.encode(countryCode, forKey: "country_code")
		}
		if countryName != nil{
			aCoder.encode(countryName, forKey: "country_name")
		}
		if datetime != nil{
			aCoder.encode(datetime, forKey: "datetime")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if instructorId != nil{
			aCoder.encode(instructorId, forKey: "instructor_id")
		}
		if joinedStudents != nil{
			aCoder.encode(joinedStudents, forKey: "joined_students")
		}
		if latitude != nil{
			aCoder.encode(latitude, forKey: "latitude")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "longitude")
		}
		if mobile != nil{
			aCoder.encode(mobile, forKey: "mobile")
		}

	}

}
