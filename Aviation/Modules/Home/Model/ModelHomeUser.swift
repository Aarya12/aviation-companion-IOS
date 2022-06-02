//
//	ModelHomeUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeUser : NSObject, NSCoding{

	var id : Int!
	var instructorId : Int!
	var studentId : Int!
	var students : ModelHomeStudent!
	var user : ModelHomeStudent!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["id"].intValue
		instructorId = json["instructor_id"].intValue
		studentId = json["student_id"].intValue
		let studentsJson = json["students"]
		if !studentsJson.isEmpty{
			students = ModelHomeStudent(fromJson: studentsJson)
		}
		let userJson = json["user"]
		if !userJson.isEmpty{
			user = ModelHomeStudent(fromJson: userJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if instructorId != nil{
			dictionary["instructor_id"] = instructorId
		}
		if studentId != nil{
			dictionary["student_id"] = studentId
		}
		if students != nil{
			dictionary["students"] = students.toDictionary()
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         instructorId = aDecoder.decodeObject(forKey: "instructor_id") as? Int
         studentId = aDecoder.decodeObject(forKey: "student_id") as? Int
         students = aDecoder.decodeObject(forKey: "students") as? ModelHomeStudent
         user = aDecoder.decodeObject(forKey: "user") as? ModelHomeStudent

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if instructorId != nil{
			aCoder.encode(instructorId, forKey: "instructor_id")
		}
		if studentId != nil{
			aCoder.encode(studentId, forKey: "student_id")
		}
		if students != nil{
			aCoder.encode(students, forKey: "students")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}