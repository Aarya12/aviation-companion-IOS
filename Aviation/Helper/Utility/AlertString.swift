//
//  AlertString.swift
//  Aviation
//
//  Created by Mac on 06/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation
struct AlertMessage {
    //login/register
    static let  FirstNameMissing: String =  "Please enter first name."
    static let  LastNameMissing: String =  "Please enter last name."
    static let  logoutMessage: String =  "Are you sure you want to logout?"
    
    static let  NameMissing: String =  "Please enter name."
    static let  EmailNameMissing: String = "Please enter email."
    static let  BirthDateMissing: String = "Please enter birth date."
    
    static let  ValidEmail: String = "Please enter valid email."
    static let  MobileMissing : String  = "Please enter mobile no."
    static let  MobileInvalid : String  = "Mobile number should be 10 characters"
    
    static let  PasswordMinMissing: String = "Password should be at least 6 characters long"
    
    static let  PasswordMissing: String = "Please enter password."
    static let  OldpasswordMissing: String = "Please enter old password."
    static let  NewpasswordMissing: String = "Please enter new password."
    static let  ConfirmPasswordMissing: String = "Please enter confirm password."
    static let  PasswordNotMatch: String = "Password doesn't match!"
    
    static let  noInternetConnection : String = "Please check your internet connection."
    
    
    static let CertificateMissing : String = "Please select certificate."

    static let ApproxHoursMissing : String = "Please enter approx hours."
    static let experienceMissing : String = "Please enter experience."
    static let RatePerHourMissing : String = "Please enter rate per hour."
    static let BaseAirPortMissing : String = "Please select base airport."
    static let  FTNMissing: String = "Please enter FTN."
    static let  LocationMissing: String = "Please enter home location."

    
    static let  StudentUnselected: String = "Please select students for this event."
    static let  dateTimeMissing: String = "Please select date and time."
    static let  AgendaMissing: String = "Please enter agenda."
    static let  DescriptionMissing: String = "Please enter description."
    static let  EventLocationMissing: String = "Please enter event location."
    static let  EventEmailsMissing: String = "Please add at least one email to send invitation."
    
    
    static let  noteDateTimeMissing : String  = "Please select note date & time."
    static let  noteTotalTimeMissing: String = "Please select total time."
    static let  noteTags : String = "Please enter / select atleast one tag."
    static let  noteMissign: String = "Please enter note."

}

