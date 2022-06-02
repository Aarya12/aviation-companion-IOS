//
//	ModelProfileMain.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class ModelProfileMain : NSObject, NSCoding{

	var airport : ModelProfileAirport!
	var airportId : Int!
	var certificateId : Int!
	var certificates : ModelProfileAirport!
	var countryCode : String!
	var email : String!
	var ftn : String!
	var id : Int!
	var mobile : String!
	var name : String!
	var profileImage : String!
    
    var backStory : String!
    var approxHours : String!
    var experienceInYear : String!
    var ratePerHour : String!
    var totalHours : String!
    var totalNotes : Int!
    var type : String!
    

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let airportJson = json["airport_data"]
		if !airportJson.isEmpty{
			airport = ModelProfileAirport(fromJson: airportJson)
		}
		airportId = json["airport_id"].intValue
		certificateId = json["certificate_id"].intValue
		let certificatesJson = json["certificates_data"]
		if !certificatesJson.isEmpty{
			certificates = ModelProfileAirport(fromJson: certificatesJson)
		}
		countryCode = json["country_code"].stringValue
		email = json["email"].stringValue
		ftn = json["ftn"].stringValue
		id = json["id"].intValue
		mobile = json["mobile"].stringValue
		name = json["name"].stringValue
		profileImage = json["profile_image"].stringValue
        
        backStory = json["back_story"].stringValue
        approxHours = json["approx_hours"].stringValue
        experienceInYear = json["experience_in_year"].stringValue
        ratePerHour = json["rate_per_hour"].stringValue
        totalHours = json["total_hours"].stringValue
        totalNotes = json["total_notes"].intValue
        type = json["type"].stringValue

	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if airport != nil{
			dictionary["airport_data"] = airport.toDictionary()
		}
		if airportId != nil{
			dictionary["airport_id"] = airportId
		}
		if certificateId != nil{
			dictionary["certificate_id"] = certificateId
		}
		if certificates != nil{
			dictionary["certificates_data"] = certificates.toDictionary()
		}
		if countryCode != nil{
			dictionary["country_code"] = countryCode
		}
		if email != nil{
			dictionary["email"] = email
		}
		if ftn != nil{
			dictionary["ftn"] = ftn
		}
		if id != nil{
			dictionary["id"] = id
		}
		if mobile != nil{
			dictionary["mobile"] = mobile
		}
		if name != nil{
			dictionary["name"] = name
		}
		if profileImage != nil{
			dictionary["profile_image"] = profileImage
		}
        
        if approxHours != nil{
            dictionary["approx_hours"] = approxHours
        }
        if backStory != nil{
            dictionary["back_story"] = backStory
        }
        if experienceInYear != nil{
            dictionary["experience_in_year"] = experienceInYear
        }
        if ratePerHour != nil{
            dictionary["rate_per_hour"] = ratePerHour
        }
        if totalHours != nil{
            dictionary["total_hours"] = totalHours
        }
        if totalNotes != nil{
            dictionary["total_notes"] = totalNotes
        }
        if type != nil{
            dictionary["type"] = type
        }

		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         airport = aDecoder.decodeObject(forKey: "airport_data") as? ModelProfileAirport
         airportId = aDecoder.decodeObject(forKey: "airport_id") as? Int
         certificateId = aDecoder.decodeObject(forKey: "certificate_id") as? Int
         certificates = aDecoder.decodeObject(forKey: "certificates_data") as? ModelProfileAirport
         countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         ftn = aDecoder.decodeObject(forKey: "ftn") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         mobile = aDecoder.decodeObject(forKey: "mobile") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String

        backStory = aDecoder.decodeObject(forKey: "back_story") as? String
        approxHours = aDecoder.decodeObject(forKey: "approx_hours") as? String
        experienceInYear = aDecoder.decodeObject(forKey: "experience_in_year") as? String
        ratePerHour = aDecoder.decodeObject(forKey: "rate_per_hour") as? String
        totalHours = aDecoder.decodeObject(forKey: "total_hours") as? String
        totalNotes = aDecoder.decodeObject(forKey: "total_notes") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if airport != nil{
			aCoder.encode(airport, forKey: "airport_data")
		}
		if airportId != nil{
			aCoder.encode(airportId, forKey: "airport_id")
		}
		if certificateId != nil{
			aCoder.encode(certificateId, forKey: "certificate_id")
		}
		if certificates != nil{
			aCoder.encode(certificates, forKey: "certificates_data")
		}
		if countryCode != nil{
			aCoder.encode(countryCode, forKey: "country_code")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if ftn != nil{
			aCoder.encode(ftn, forKey: "ftn")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if mobile != nil{
			aCoder.encode(mobile, forKey: "mobile")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "profile_image")
		}

        if approxHours != nil{
            aCoder.encode(approxHours, forKey: "approx_hours")
        }
        if backStory != nil{
            aCoder.encode(backStory, forKey: "back_story")
        }
        if experienceInYear != nil{
            aCoder.encode(experienceInYear, forKey: "experience_in_year")
        }
        if ratePerHour != nil{
            aCoder.encode(ratePerHour, forKey: "rate_per_hour")
        }
        if totalHours != nil{
            aCoder.encode(totalHours, forKey: "total_hours")
        }
        if totalNotes != nil{
            aCoder.encode(totalNotes, forKey: "total_notes")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }

	}

}
