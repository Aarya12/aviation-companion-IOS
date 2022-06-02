//
//	ModelEventsJoinedStudent.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelEventsJoinedStudent {

	var eventId : Int!
	var id : Int!
	var studentId : ModelEventsStudentId!


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
			studentId = ModelEventsStudentId(fromJson: studentIdJson)
		}
	}
}
