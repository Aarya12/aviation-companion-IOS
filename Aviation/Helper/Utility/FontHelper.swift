//
//  FondHelper.swift
//  Aviation
//
//  Created by Mac on 06/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation
import UIKit
// Usage Examples
let fontRegular13   = Font(.installed(.Regular), size: .standard(.h513)).instance
let system12            = Font(.system, size: .standard(.h5)).instance
let fontRegular12        = Font(.installed(.Regular), size: .standard(.h5)).instance
let fontRegular14        = Font(.installed(.Regular), size: .standard(.h4)).instance
let fontRegular15        = Font(.installed(.Regular), size: .standard(.h315)).instance

let fontRegular16        = Font(.installed(.Regular), size: .standard(.h3)).instance
//semi bold
let fontSemiBold12        = Font(.installed(.SemiBold), size: .standard(.h5)).instance
let fontSemiBold14        = Font(.installed(.SemiBold), size: .standard(.h4)).instance
let fontSemiBold16        = Font(.installed(.SemiBold), size: .standard(.h3)).instance
let fontBold20        = Font(.installed(.Bold), size: .standard(.h1)).instance
let fontSemiBold22        = Font(.installed(.SemiBold), size: .custom(22.0)).instance

enum FontName: String {
    case Bold   =  "Metropolis-Bold"
    case Regular   =  "Metropolis-Regular"
    case MediumItalic   =  "Metropolis-MediumItalic"
    case SemiBoldItalic   =  "Metropolis-SemiBoldItalic"
    case RegularItalic   =  "Metropolis-RegularItalic"
    case ThinItalic   =  "Metropolis-ThinItalic"
    case ExtraLightItalic   =  "Metropolis-ExtraLightItalic"
    case ExtraBold   =  "Metropolis-ExtraBold"
    case LightItalic   =  "Metropolis-LightItalic"
    case BoldItalic   =  "Metropolis-BoldItalic"
    case Thin   =  "Metropolis-Thin"
    case Medium   =  "Metropolis-Medium"
    case SemiBold   =  "Metropolis-SemiBold"
    case ExtraBoldItalic   =  "Metropolis-ExtraBoldItalic"
    case Black   =  "Metropolis-Black"
    case BlackItalic   =  "Metropolis-BlackItalic"
    case ExtraLight   =  "Metropolis-ExtraLight"
    case Light   =  "Metropolis-Light"

}

struct Font {

    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum StandardSize: Double {
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h315 = 15.0
        case h4 = 14.0
        case h513 = 13.0
        case h5 = 12.0
        case h6 = 10.0
    }
   
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}
class Utility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}

func fontInProject() {
    for family in UIFont.familyNames {
        print("\(family)")
        for name in UIFont.fontNames(forFamilyName: family) {
            print("   \(name)")
        }
    }
}

