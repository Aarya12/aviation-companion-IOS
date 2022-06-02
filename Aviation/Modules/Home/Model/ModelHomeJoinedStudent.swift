//
//	ModelHomeJoinedStudent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeJoinedStudent : NSObject, NSCoding{

	var eventId : Int!
	var id : Int!
	var studentId : ModelHomeStudentId!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		eventId = json["event_id"].intValue
		id = json["id"].intValue
		let studentIdJson = json["student_id"]
		if !studentIdJson.isEmpty{
			studentId = ModelHomeStudentId(fromJson: studentIdJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if eventId != nil{
			dictionary["event_id"] = eventId
		}
		if id != nil{
			dictionary["id"] = id
		}
		if studentId != nil{
			dictionary["student_id"] = studentId.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         eventId = aDecoder.decodeObject(forKey: "event_id") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         studentId = aDecoder.decodeObject(forKey: "student_id") as? ModelHomeStudentId

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if eventId != nil{
			aCoder.encode(eventId, forKey: "event_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if studentId != nil{
			aCoder.encode(studentId, forKey: "student_id")
		}

	}

}