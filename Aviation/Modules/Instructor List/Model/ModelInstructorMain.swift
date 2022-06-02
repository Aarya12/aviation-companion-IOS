//
//	ModelInstructorMain.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ModelInstructorMain{

	var airport : ModelProfileAirport!
	var airportId : Int!
	var approxHours : String!
	var distance : Double!
	var email : String!
	var experienceInYear : String!
	var id : Int!
	var isAlreadyStudent : String!
	var name : String!
	var profileImage : String!
	var ratePerHour : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let airportJson = json["airport"]
		if !airportJson.isEmpty{
			airport = ModelProfileAirport(fromJson: airportJson)
		}
		airportId = json["airport_id"].intValue
		approxHours = json["approx_hours"].stringValue
		distance = json["distance"].doubleValue
		email = json["email"].stringValue
		experienceInYear = json["experience_in_year"].stringValue
		id = json["id"].intValue
		isAlreadyStudent = json["is_already_student"].stringValue
		name = json["name"].stringValue
		profileImage = json["profile_image"].stringValue
		ratePerHour = json["rate_per_hour"].stringValue
	}

}
