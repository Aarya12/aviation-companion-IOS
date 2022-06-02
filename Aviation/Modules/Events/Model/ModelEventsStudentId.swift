//
//	ModelEventsStudentId.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelEventsStudentId {

	var email : String!
	var id : Int!
	var name : String!
	var profileImage : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		email = json["email"].stringValue
		id = json["id"].intValue
		name = json["name"].stringValue
		profileImage = json["profile_image"].stringValue
	}

}
