//
//	ModelEventsLocation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelEventsLocation {

	var id : Int!
	var ident : String!
	var isoCountry : String!
	var isoRegion : String!
	var lat : String!
	var lng : String!
	var localCode : String!
	var name : String!
	var type : String!
	var unqId : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["id"].intValue
		ident = json["ident"].stringValue
		isoCountry = json["iso_country"].stringValue
		isoRegion = json["iso_region"].stringValue
		lat = json["lat"].stringValue
		lng = json["lng"].stringValue
		localCode = json["local_code"].stringValue
		name = json["name"].stringValue
		type = json["type"].stringValue
		unqId = json["unq_id"].stringValue
	}

}
