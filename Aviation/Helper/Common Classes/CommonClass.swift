//
//  CommonClass.swift
//  Aviation
//
//  Created by Mac on 04/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

//
//  CommonClass.swift
//  Badi
//
//  Created by Mac on 03/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire

private let _sharedInstance = CommonClass()

let appDelObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate

let PlaceholderImage = UIImage(named: "ic_logo")

typealias anyActionAlias = ((_ sender : Any) -> Void)
typealias buttonActionAlias = ((_ sender: UIButton) -> Void)
typealias controlActionAlias = ((_ sender: UIControl) -> Void)
typealias voidCloser = (() -> Void)
typealias BoolToVoidCloser = ((Bool) -> Void)

class CommonClass: NSObject {
    
    class var sharedInstance: CommonClass {
        return _sharedInstance
    }
    
    static let myAppDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate

        
    func isValidEmail(testStr:String) -> Bool
      {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          let result = emailTest.evaluate(with: testStr)
          return result
      }
    
    func getCurrentTimeZone() -> String{
        
        return String (TimeZone.current.identifier)
    }
    
    func isReachable() -> Bool
       {
           let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
           return (reachabilityManager?.isReachable)!
       }
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    func getCurrentTime() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        return result
    }
    
    func NewLineHtml(str:String) -> String
    {
        let newText = str.replacingOccurrences(of: "\n", with: "<br>")
        return newText
    }

    func setShadow(obj:Any, cornurRadius:CGFloat, ClipToBound:Bool, masksToBounds:Bool, shadowColor:String, shadowOpacity:Float, shadowOffset:CGSize, shadowRadius:CGFloat, shouldRasterize:Bool, shadowPath:CGRect) {
        if obj is UIView {
            let tempView:UIView = obj as! UIView
            tempView.clipsToBounds = ClipToBound
            tempView.layer.cornerRadius = cornurRadius
            tempView.layer.shadowOffset = shadowOffset
            tempView.layer.shadowOpacity = shadowOpacity
            tempView.layer.shadowRadius = shadowRadius
            tempView.layer.shadowColor = self.getColorIntoHex(Hex: shadowColor).cgColor
            tempView.layer.masksToBounds =  masksToBounds
            tempView.layer.shouldRasterize = shouldRasterize
            tempView.layer.shadowPath = UIBezierPath(roundedRect: tempView.bounds, cornerRadius: cornurRadius).cgPath
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    
    // For Get Color Using HexCode
    func getColorIntoHex(Hex:String) -> UIColor {
        if Hex.isEmpty {
            return UIColor.clear
        }
        let scanner = Scanner(string: Hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return UIColor.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
    
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    func getDate(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date) // replace Date String
    }
    
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
   
    }
    func roundDifferentCorners(view :UIView,topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0,borderColor:UIColor) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: view.bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        view.layer.mask = shape
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.lineWidth = 1.0
        borderLayer.frame = view.bounds
        borderLayer.path = shape.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.white.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        view.layer.addSublayer(borderLayer)
        view.addShadow()
        
    }
    
    func AppTextFieldStyle(view :UIView, corners: UIRectCorner, radius: CGFloat,borderColor:UIColor){
         let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
       
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path // Reuse the Bezier path
        borderLayer.backgroundColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        borderLayer.borderColor = UIColor.lightText.cgColor
        borderLayer.borderWidth = 1.0
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.frame = view.bounds
       // view.addShadowView()
        
        view.layer.addSublayer(borderLayer)
        
    }
    func AppButtonStyle(view :UIView, corners: UIRectCorner, radius: CGFloat,borderColor:UIColor){
         let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
        view.layer.mask = mask
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path // Reuse the Bezier path
        borderLayer.backgroundColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.frame = view.bounds
        view.layer.insertSublayer(borderLayer, at: 0)
    }
    func roundCornersWithBoarder(view :UIView, corners: UIRectCorner, radius: CGFloat,borderColor:UIColor){
         let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
        view.layer.mask = mask
        
        // Add border
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor//borderColor.cgColor
        borderLayer.frame = view.bounds
//        borderLayer.shadowColor = UIColor.darkGray.cgColor;
//        borderLayer.shadowOpacity = 0.7;
//        borderLayer.shadowRadius = 5
//        borderLayer.shadowOffset  = CGSize(width: -5, height: -10);
//        borderLayer.masksToBounds = false;
        
        //view.shadow = true
    }
    func shadowWithCornerAndWidth(view :UIView, corners: UIRectCorner, radius: CGFloat,borderColor:UIColor,width: CGFloat){
        
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
        view.layer.mask = mask
        
       // view.layer.shadowColor = UIColor.black.cgColor;
        //view.layer.shadowOpacity = 0.5;
        //view.layer.shadowOffset  = CGSize(width :0, height :1)
        //view.layer.masksToBounds = false;
        
        view.layer.borderWidth   = width
        view.backgroundColor     = UIColor.white;
    }
    
    func shadowWithCorner(view :UIView, corners: UIRectCorner, radius: CGFloat,borderColor:UIColor){
        
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
        view.layer.mask = mask
        
        view.layer.shadowColor = UIColor.black.cgColor;
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowOffset  = CGSize(width :0, height :1)
        view.layer.masksToBounds = false;
        
        view.layer.borderWidth   = 0.5;
        view.backgroundColor     = UIColor.white;
    }
    
    
//    func openSideMenu()
//    {
//        let storyboard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//
//        SideMenuManager.menuRightNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
//        //MenuPushStyle
//        SideMenuManager.menuFadeStatusBar = false
//        SideMenuManager.menuWidth = 275;
//
//    }
//    func openLeftSideMenu()
//    {
//        let storyboard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//
//              SideMenuManager.menuLeftNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
//              //MenuPushStyle
//        SideMenuManager.menuBlurEffectStyle = .dark
//              SideMenuManager.menuFadeStatusBar = false
//              SideMenuManager.menuWidth = 275;
//    }
    
    func ConverDateFromString(datestring:String) -> Date?
    {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let s = dateFormatter.date(from: datestring)
        
        return s
    }
    
    func convertDateFormatter(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        
        return timeStamp
    }
    
    func convertDateFormatter1(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM dd,yyyy"//this your string date format
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        
        return timeStamp
    }
    
    func convertDateFormatter123(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM dd,yyyy"//this your string date format
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        
        return timeStamp
    }
    
    func convertDateFormatter12(date: String) -> String
       {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "E, MM dd,yyyy"//this your string date format
           
           let date = dateFormatter.date(from: date)
           dateFormatter.dateFormat = "dd MMMM yyyy"///this is what you want to convert format
           dateFormatter.timeZone = TimeZone.current
           let timeStamp = dateFormatter.string(from: date!)
           
           
           return timeStamp
       }
    
    func convertOnlyDateFormatter1(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"//this your string date format
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MM-yyyy"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        
        return timeStamp
    }
    
    func convertOnlyTimeFormatter1(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"//this your string date format
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date!)
        
        
        return timeStamp
    }
    func UTCToLocalAMFromService(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocalAM(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    
    
    func UTCToLocalOnlyDate(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd  MMM  yyyy"
        
        return dateFormatter.string(from: dt!)
    }
    
}

extension UIViewController {

    func getPreviousViewController() -> UIViewController? {
        guard let _ = self.navigationController else {
            return nil
        }

        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }

        guard viewControllers.count >= 2 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
         return topViewController?.preferredStatusBarStyle ?? .default
      }
   func backToViewController(vc: Any) {
      // iterate to find the type of vc
      for element in viewControllers as Array {
        if "\(type(of: element)).Type" == "\(type(of: (vc as AnyObject)))" {
            self.popToViewController(element, animated: true)
            break
         }
      }
   }

}

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}

