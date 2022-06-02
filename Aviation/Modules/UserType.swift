//
//  UserType.swift
//  Aviation
//
//  Created by Zestbrains on 09/12/21.
//

import Foundation
import UIKit

//MARK: - USER TYPES
enum userType : String {
    case Instructor = "instructor"
    case Student = "student"
}

var AppSelectedUserType : userType {
    get {
        let type = UserDefaults.standard.string(forKey: "app_selected_user_type") ?? "instructor"
        print("type : ",type)
        return userType(rawValue: type) ?? .Instructor
    }
    set{
        UserDefaults.standard.set(newValue.rawValue, forKey: "app_selected_user_type")
        UserDefaults.standard.synchronize()
    }
}

//ISFROM Screen
enum isFrom {
    case HomeSearch
    case HomeViewAll
}
