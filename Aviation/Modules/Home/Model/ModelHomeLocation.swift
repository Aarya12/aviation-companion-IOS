//
//	ModelHomeLocation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelHomeLocation : NSObject, NSCoding{

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

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if ident != nil{
			dictionary["ident"] = ident
		}
		if isoCountry != nil{
			dictionary["iso_country"] = isoCountry
		}
		if isoRegion != nil{
			dictionary["iso_region"] = isoRegion
		}
		if lat != nil{
			dictionary["lat"] = lat
		}
		if lng != nil{
			dictionary["lng"] = lng
		}
		if localCode != nil{
			dictionary["local_code"] = localCode
		}
		if name != nil{
			dictionary["name"] = name
		}
		if type != nil{
			dictionary["type"] = type
		}
		if unqId != nil{
			dictionary["unq_id"] = unqId
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
         ident = aDecoder.decodeObject(forKey: "ident") as? String
         isoCountry = aDecoder.decodeObject(forKey: "iso_country") as? String
         isoRegion = aDecoder.decodeObject(forKey: "iso_region") as? String
         lat = aDecoder.decodeObject(forKey: "lat") as? String
         lng = aDecoder.decodeObject(forKey: "lng") as? String
         localCode = aDecoder.decodeObject(forKey: "local_code") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         unqId = aDecoder.decodeObject(forKey: "unq_id") as? String

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
		if ident != nil{
			aCoder.encode(ident, forKey: "ident")
		}
		if isoCountry != nil{
			aCoder.encode(isoCountry, forKey: "iso_country")
		}
		if isoRegion != nil{
			aCoder.encode(isoRegion, forKey: "iso_region")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if localCode != nil{
			aCoder.encode(localCode, forKey: "local_code")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if unqId != nil{
			aCoder.encode(unqId, forKey: "unq_id")
		}

	}

}