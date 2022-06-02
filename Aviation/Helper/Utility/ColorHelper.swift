//
//  ColorHelper.swift
//  Aviation
//
//  Created by Mac on 04/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
extension UIColor{
    //Colors are computed class properties. To refrence the class, use self
    class var appColor:UIColor{
        return hexStringToUIColor(hex: "#28C6C6")
    }

    class var crust:UIColor{
        return self.hexColor(0xe39448, alpha: 1.0)
    }

    //The hexColor method is a class method taking a UInt32 and alpha value and returns a color. See http://bit.ly/HexColorsWeb onhow it works.

    class func hexColor(_ hexColorNumber:UInt32, alpha: CGFloat) -> UIColor {
        let red = (hexColorNumber & 0xff0000) >> 16
        let green = (hexColorNumber & 0x00ff00) >> 8
        let blue =  (hexColorNumber & 0x0000ff)
        return self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}


extension UIColor {
   convenience init(r: Int, g: Int, b: Int) {
       assert(r >= 0 && r <= 255, "Invalid red component")
       assert(g >= 0 && g <= 255, "Invalid green component")
       assert(b >= 0 && b <= 255, "Invalid blue component")

       self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let graphYellowColor = UIColor(red: 246/255, green: 158/255, blue: 41/255, alpha: 1.0)
    static let graphRedColor = UIColor(red: 226/255, green: 55/255, blue: 68/255, alpha: 1.0)
    static let selectedGreenColor = UIColor(red: 2/255, green: 145/255, blue: 28/255, alpha: 1.0)
    static let shadowColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.07)
}

extension UIColor {
    
    static let HeaderTitleBlackColor =  UIColor(red: 49.0/255.0, green: 48.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let HeaderInfoGrayColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let PlaceholderGrayColor:UIColor = UIColor.init(red: 182.0/255.0, green: 182.0/255.0, blue: 182.0/255.0, alpha: 1.0)
     static let TextFieldGrayColor:UIColor = UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    static let SubmitButtonColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
     static let TitleButtonColor:UIColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    static let BodyInfoLightGrayColor:UIColor = UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    static let ThemeRedColor:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let Themegradiant1:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let Themegradiant2:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let TextFieldBorderColor:UIColor = UIColor.init(red: 226.0/255.0, green: 230.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let themeBlueColor:UIColor = UIColor.init(red: 61.0/255.0, green: 189.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let cellBorderColor:UIColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let dashedBorder:UIColor = UIColor.init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 0.1)
    
    
    
    static let themeShadowColor:UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
    
    static let themeGrayColor:UIColor = UIColor.init(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 1.0)
    
    static let themeBlueColorUneri:UIColor = UIColor.init(red: 13/255.0, green: 116/255.0, blue: 148/255.0, alpha: 1.0)

    static let themeGreenColorUneri =  UIColor(red: 55.0/255.0, green: 158.0/255.0, blue: 135.0/255.0, alpha: 1.0)

    
    static let redColor:UIColor = UIColor.init(red: 250/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    static let orangeColor:UIColor = UIColor.init(red: 248/255.0, green: 90/255.0, blue: 84/255.0, alpha: 1.0)

    
    static let yellowColor:UIColor = UIColor.init(red: 255/255.0, green: 196/255.0, blue: 03/255.0, alpha: 1.0)

    static let approveColor:UIColor = UIColor.init(red: 100/255.0, green: 183/255.0, blue: 163/255.0, alpha: 1.0)

    
    static let healthfirst:UIColor = UIColor.init(red: 98/255.0, green: 108/255.0, blue: 229/255.0, alpha: 1.0)
    
    static let healthsecond:UIColor = UIColor.init(red: 47/255.0, green: 132/255.0, blue: 161/255.0, alpha: 1.0)

    
    static let healththird:UIColor = UIColor.init(red: 54/255.0, green: 144/255.0, blue: 155/255.0, alpha: 1.0)

    
    static let healthfour:UIColor = UIColor.init(red: 67/255.0, green: 74/255.0, blue: 164/255.0, alpha: 1.0)
    
    static let healthfive:UIColor = UIColor.init(red: 79/255.0, green: 162/255.0, blue: 145/255.0, alpha: 1.0)

    

    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func themeTintColor() -> UIColor {
        return UIColor.init(red: 0, green: 122, blue: 255)
    }
    
    
}
