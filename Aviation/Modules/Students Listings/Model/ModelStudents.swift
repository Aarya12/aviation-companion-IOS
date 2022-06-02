//
//	ModelStudents.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelStudents {

	var email : String!
	var id : Int!
	var isAlreadyStudent : String!
	var name : String!
	var profileImage : String!
    var total_notes : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		email = json["email"].stringValue
		id = json["id"].intValue
		isAlreadyStudent = json["is_already_student"].stringValue
		name = json["name"].stringValue
		profileImage = json["profile_image"].stringValue
        total_notes = json["total_notes"].intValue
	}

}
