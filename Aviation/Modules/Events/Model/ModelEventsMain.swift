//
//	ModelEventsMain.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelEventsMain {

	var agenda : String!
	var countryCode : String!
	var countryName : String!
	var datetime : String!
	var descriptionField : String!
	var id : Int!
	var instructorId : Int!
	var joinedStudents : [ModelEventsJoinedStudent]!
	var latitude : String!
	var location : ModelEventsLocation!
	var longitude : String!
	var mobile : String!
    var instructor : ModelEventInstructor!
    var event_emails : [ModelEventEmails]!


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
		joinedStudents = [ModelEventsJoinedStudent]()
		let joinedStudentsArray = json["joined_students"].arrayValue
		for joinedStudentsJson in joinedStudentsArray{
			let value = ModelEventsJoinedStudent(fromJson: joinedStudentsJson)
			joinedStudents.append(value)
		}
		latitude = json["latitude"].stringValue
		let locationJson = json["location"]
		if !locationJson.isEmpty{
			location = ModelEventsLocation(fromJson: locationJson)
		}
		longitude = json["longitude"].stringValue
		mobile = json["mobile"].stringValue
        
        let instructorJSon = json["instructor"]
        if !instructorJSon.isEmpty{
            instructor = ModelEventInstructor(fromJson: instructorJSon)
        }
        
        event_emails = [ModelEventEmails]()
        let emailsArray = json["event_emails"].arrayValue
        for emailJSon in emailsArray{
            let value = ModelEventEmails(fromJson: emailJSon)
            event_emails.append(value)
        }

	}
}
