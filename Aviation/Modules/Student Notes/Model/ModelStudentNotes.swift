//
//	ModelStudentNotes.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class ModelStudentNotes{

	var datetime : String!
	var id : Int!
	var note : String!
    var pdfUrl : String!
	var privateNote : String!
	var studentId : Int!
	var tags : String!
	var totalHours : String!
    
    var created_at : String!
    var updated_at : String!
    var instructorId : ModelEventsStudentId!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		datetime = json["datetime"].stringValue
		id = json["id"].intValue
		note = json["note"].stringValue
        pdfUrl = json["pdf_url"].stringValue
		privateNote = json["private_note"].stringValue
		studentId = json["student_id"].intValue
		tags = json["tags"].stringValue
		totalHours = json["total_hours"].stringValue
        
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        instructorId = ModelEventsStudentId(fromJson: json["instructor_id"])
	}

}
