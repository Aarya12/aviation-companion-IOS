//
//  GeneralUtility.swift
//  Aviation
//
//  Created by Devubha Manek on 12/11/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import MobileCoreServices
import SDWebImage
import Haptico


class CustomDashedView: UIView {

    @IBInspectable var cornerRadiusForDashhed: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

class GeneralUtility: NSObject {

    //MARK: - Shared Instance
    static let sharedInstance : GeneralUtility = {
        let instance = GeneralUtility()
        return instance
    }()
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
                print("path : \(dbPath)")
            } catch let error1 as NSError {
                error = error1
            }
        }
    }
    
    func addButtonTapHaptic() {
        Haptico.shared().generate(.light)
    }
    
    func addErrorHaptic() {
        Haptico.shared().generate(.error)
    }
    
    func addSuccessHaptic() {
        Haptico.shared().generate(.success)
    }
    
    func addWarningHaptic() {
        Haptico.shared().generate(.warning)
    }

    
    func setImageWithSDWEBImage(imgView: UIImageView?, placeHolderImage: UIImage?, imgPath: String) {
           UIView.performWithoutAnimation {
               let imageNew = imgPath
               if let _ = URL(string: imageNew), let imgView = imgView {
                   DispatchQueue.main.async {
                       var thumbnailSize = imgView.frame.size
                       thumbnailSize.width = thumbnailSize.width * UIScreen.main.scale
                       thumbnailSize.height = thumbnailSize.height * UIScreen.main.scale
                       SDImageCoderHelper.defaultScaleDownLimitBytes = UInt(imgView.frame.size.width * imgView.frame.size.height * 4)
                       let optins: SDWebImageOptions = [.retryFailed]
                       imgView.sd_imageTransition = .fade
                       imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                       imgView.sd_setImage(with: URL(string: imgPath), placeholderImage: placeHolderImage, options: optins, context: [.imageThumbnailPixelSize : thumbnailSize])
                   }
                   
               } else {
                   DispatchQueue.main.async {
                       //                    imgView?.sd_imageTransition = .none
                       //                    imgView?.image = placeHolderImage
                   }
               }
           }
       }
}

func setView(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
    })
}




func getDateFromString(date:String, fromFormate : String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'") -> Date {
    
   // NSLog("Str date :%@ ",date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormate //"yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone.current
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date)
    print("date :\(dt)")
    return dt ?? Date()
}


func getStrDateFromDate(date:Date , formate : String = "dd MMM hh:mm a" ) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formate
    dateFormatter.locale = Locale.current
    let dt = dateFormatter.string(from: date)
    return dt
}


func getStrDateFromDate(date:String ,fromFormat : String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat : String = "dd-MMM-yyyy hh:mm a") -> (String) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date) ?? Date()
    
    dateFormatter.dateFormat = toFormat
    let date = dateFormatter.string(from: dt)
    
    return date
}


//MARK: - StoryBoards Constant
struct storyBoards {

    static let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let LoginRegister = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let Home = UIStoryboard(name: "Home", bundle: Bundle.main)
    static let Student = UIStoryboard(name: "Student", bundle: Bundle.main)
    static let Event = UIStoryboard(name: "Event", bundle: Bundle.main)

}

//MARK: - Device Type
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XS_MAX     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH         = UIScreen.main.bounds.size.width
    static let HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
}

// MARK: - Hex to UIcolor
func hexStringToUIColor (hex:String) -> UIColor {
    
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(viewController: slide.mainViewController)
        //        }
        return viewController
    }
}

//MARK: - check string nil
func createString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
        
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

//MARK: - check string nil
func createFloatToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.2f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

func createDoubleToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.1f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

//MARK: - check string nil
func createIntToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

func createStringToint(value: AnyObject) -> Int
{
    var returnString: Int = 0
    
    if  value as! String == ""
    {
        returnString = 0
    }else{
        returnString = Int(value as! String)!
    }
    
    return returnString
}
func creatArray(value: AnyObject) -> NSMutableArray
{
    var tempArray = NSMutableArray()
    
    if let arrData: NSArray = value as? NSArray
    {
        tempArray = NSMutableArray.init(array: arrData)
    }
    else if let _: NSNull = value as? NSNull
    {
        tempArray = NSMutableArray.init()
    }
    
    return tempArray
}
class CircleControl: UIControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
func creatDictnory(value: AnyObject) -> NSMutableDictionary
{
    var tempDict = NSMutableDictionary()
    
    if let DictData: NSDictionary = value as? NSDictionary
    {
        tempDict = NSMutableDictionary.init()
        tempDict.addEntries(from:DictData as! [AnyHashable : Any])
    }
    else if let _: NSNull = value as? NSNull
    {
        tempDict = NSMutableDictionary.init()
    }
    
    return tempDict
}

func localToUTC(dateStr: String,fromFomate : String , ToFormate : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFomate
    dateFormatter.calendar = Calendar.current
    dateFormatter.timeZone = TimeZone.current
    
    if let date = dateFormatter.date(from: dateStr) {
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = ToFormate
    
        return dateFormatter.string(from: date)
    }
    return ""
}


func UTCToLocal(date:String,fromFomate : String , ToFormate : String) -> String {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFomate
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = ToFormate
    var str = ""
    if dt != nil
    {
        str = dateFormatter.string(from: dt!)
    }
    return str
}

//MARK: - Get Bool From Dictionary
func getBoolFromDictionary(dictionary:NSDictionary, key:String) -> Bool {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string.lowercased() == "null" || string == "nil") {
            return false
        }
        if (string.isNumber) {
            
            return Bool(NSNumber(integerLiteral: Int(string)!))
        } else if (string.lowercased() == "false" || string == "0" || string == "no") {
            return false
            
        } else if (string.lowercased() == "true" || string == "1" || string == "yes") {
            return true
            
        } else {
            return false
        }
    }
    return false
}

//MARK: - Get String From Dictionary
func getStringFromDictionary(dictionary:NSDictionary, key:String) -> String {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return ""
        }
        return string.removeWhiteSpace() as String
    }
    return ""
}

//MARK: - Get Dictionary From Dictionary
func getDictionaryFromDictionary(dictionary:NSDictionary, key:String) -> NSDictionary {
    
    if let value = dictionary[key] as? NSDictionary {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSDictionary()
        }
        return value
    }
    return NSDictionary()
}
//MARK: - Get Array From Dictionary
func getArrayFromDictionary(dictionary:NSDictionary, key:String) -> NSArray {
    
    if let value = dictionary[key] as? NSArray {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSArray()
        }
        return value
    }
    return NSArray()
}

//MARK: - Get Array From Dictionary
func getDictionryArrayFromDictionary(dictionary:NSDictionary, key:String) -> [NSDictionary] {
    
    if let value = dictionary[key] as? [NSDictionary] {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return [NSDictionary]()
        }
        return value
    }
    return [NSDictionary]()
}

//MARK: - Set Color Method
func setColor(r: Float, g: Float, b: Float, aplha: Float)-> UIColor {
    return UIColor(red: CGFloat(Float(r / 255.0)), green: CGFloat(Float(g / 255.0)) , blue: CGFloat(Float(b / 255.0)), alpha: CGFloat(aplha))
}
//MARK: - Color
struct Color
{
    static let textColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    static let keyboardHeaderColor = UIColor(red: 27.0 / 255.0, green: 170.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
}

/// to set the colors of  strings
func changeTextColors(fullStr: String, str: String,color1:UIColor,color2:UIColor) -> NSAttributedString
{
    let AttributeString = NSMutableAttributedString(string: fullStr)
    let ran = (fullStr as NSString).range(of: fullStr)
    AttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color1, range:ran)
    let range = (fullStr as NSString).range(of: str)
    AttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color2 , range: range)
    return AttributeString
}


func addAttributesToCustomString(fullStr: String, str: String,attribute : [NSAttributedString.Key : Any]) -> NSAttributedString
{
    let AttributeString = NSMutableAttributedString(string: fullStr)
    let range = (fullStr as NSString).range(of: str)
    AttributeString.addAttributes(attribute, range: range)
    return AttributeString
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


extension UIBezierPath {

    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != 0 {
            path.move(to: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }

        if topRightRadius != 0 {
            path.addLine(to: CGPoint(x: topRight.x - topRightRadius, y: topRight.y))
            path.addArc(tangent1End: topRight, tangent2End: CGPoint(x: topRight.x, y: topRight.y + topRightRadius), radius: topRightRadius)
        }
        else {
            path.addLine(to: topRight)
        }

        if bottomRightRadius != 0 {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius))
            path.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bottomRight.x - bottomRightRadius, y: bottomRight.y), radius: bottomRightRadius)
        }
        else {
            path.addLine(to: bottomRight)
        }

        if bottomLeftRadius != 0 {
            path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y))
            path.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius), radius: bottomLeftRadius)
        }
        else {
            path.addLine(to: bottomLeft)
        }

        if topLeftRadius != 0 {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius))
            path.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y), radius: topLeftRadius)
        }
        else {
            path.addLine(to: topLeft)
        }

        path.closeSubpath()
        cgPath = path
    }
}


@IBDesignable
open class VariableCornerRadiusView: UIView  {

    private func applyRadiusMaskFor() {
        let path = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        //layer.mask = shape
        self.layer.insertSublayer(shape, at: 0)
        //shape.backgroundColor = UIColor.white.cgColor
        //layer.addSublayer(shape)

        //self.addShadow()

    }

    @IBInspectable
    open var topLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    open var topRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    open var bottomLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable
    open var bottomRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        applyRadiusMaskFor()
        //add_shadow(demoView: self, height: 2)
    }
}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            navigationBar.barTintColor = uiColor
        }
        get {
            guard let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
}
@IBDesignable class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = .white
    @IBInspectable var secondColor: UIColor = .clear
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.58, b: -0.76, c: 0.43, d: -3.4, tx: 0.55, ty: 2.98))

        layer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)

        layer.position = self.center
        return layer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        //updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
//    func updateGradientDirection() {
//        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
//    }
}

var isIphoneXOrLonger: Bool {
    // 812.0 / 375.0 on iPhone X, XS.
    // 896.0 / 414.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 896.0 / 414.0
}

struct MyUserDefaults {
    static let UserData = "Userdata"
    static let Filter = "Filter"
}

//MARK: - Get/Set UserDefaults
func setMyUserDefaults(value:Any, key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getMyUserDefaults(key:String)->Any {
    return UserDefaults.standard.value(forKey: key) ?? ""
}

class UserInfo {
    
    //MARK: - Shared Instance
    static let sharedInstance : UserInfo = {
        let instance = UserInfo()
        return instance
    }()
    
    
    //MARK: - Set and Get Login Status
    func isUserLogin() -> Bool {
        if let strLoginStatus:Bool = UserDefaults.standard.bool(forKey: "login") as Bool? {
            let status:Bool = strLoginStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    
    //MARK: - Set and Get Location Status
    func isLocationAllow() -> Bool {
        if let strLoginStatus:Bool = UserDefaults.standard.bool(forKey: "location") as Bool? {
            let status:Bool = strLoginStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    
    //MARK: - Set and Get Location Status
    func isLocationServiceOn() -> Bool {
        if let strLoginStatus:Bool = UserDefaults.standard.bool(forKey: "LocationService") as Bool? {
            let status:Bool = strLoginStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    
    //MARK: - Set and Get RespondMode Status
    func isRespondModeOn() -> Bool {
        if let strLoginStatus:Bool = UserDefaults.standard.bool(forKey: "respondMode") as Bool? {
            let status:Bool = strLoginStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    
    func setUserLogin(isLogin:Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "login")
        UserDefaults.standard.synchronize()
    }
    
    func setUserLocation(isAllow:Bool) {
        
        UserDefaults.standard.set(isAllow, forKey: "location")
        UserDefaults.standard.synchronize()
    }
    
    func setLocationService(isEnable:Bool) {
        
        UserDefaults.standard.set(isEnable, forKey: "LocationService")
        UserDefaults.standard.synchronize()
    }
    
    func setLoginUser(loginUser:String) {
        
        UserDefaults.standard.set(loginUser, forKey: "loginUser")
        UserDefaults.standard.synchronize()
    }
    
    func setResponsMode(isOn:Bool) {
        
        UserDefaults.standard.set(isOn, forKey: "respondMode")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Set and Get Register Status
    func isUserRegister() -> Bool {
        
        if let strRegisterStatus:Bool = UserDefaults.standard.bool(forKey: "register") as Bool? {
            let status:Bool = strRegisterStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    
    func setUserRegister(isRegister:Bool) {
        
        UserDefaults.standard.set(isRegister, forKey: "register")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Set and Get Logined user details
    func getUserInfo(key: String) -> String {
        
        if let dictUserInfo:NSDictionary = UserDefaults.standard.dictionary(forKey: "Userdata") as NSDictionary? {
            print("Userdata : ",dictUserInfo)
            if let strValue = dictUserInfo.value(forKey: key) {
                return "\(strValue)"
            }
        }
        return ""
        //        if let dictUserInfo:NSDictionary = UserDefaults.standard.dictionary(forKey: "result") as NSDictionary? {
        ////            print("Userdata : ",dictUserInfo)
        //            if let strValue = dictUserInfo.value(forKey: key) {
        //                return "\(strValue)"
        //            }
        //        }
        //        return ""
    }
    
    //MARK: - Set and Get Logined user details
    func getUserTokan(key: String) -> String {
        
        if let dictUserInfo:NSDictionary = UserDefaults.standard.dictionary(forKey: "Userdata") as NSDictionary? {
            print("Userdata : ",dictUserInfo)
            if let strValue = dictUserInfo.value(forKey: key) {
                return "\(strValue)"
            }
        }
        return ""
    }
    
    func setUserInfo(dictData: NSDictionary) {
        
        if UserDefaults.standard.object(forKey: "Userdata") != nil {
            UserDefaults.standard.removeObject(forKey: "Userdata")
            UserDefaults.standard.synchronize()
        }
        
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: dictData), forKey: "Userdata")
        //        UserDefaults.standard.set(dictData, forKey: "result")
        UserDefaults.standard.synchronize()
    }
}

class Alerts {
    
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}

@IBDesignable class BigSwitch: UISwitch {
    
    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}

class Slider: UISlider {
    
    @IBInspectable var thumbImage: UIImage?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var SliderScale : CGFloat = 1 {
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: SliderScale, y: SliderScale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}



extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UISegmentedControl
{

    @IBInspectable public var font: UIFont {
        get {
            return self.font
        }
        set {
            defaultConfiguration(font: newValue, color: .white)
            selectedConfiguration(font: newValue, color: hexStringToUIColor(hex: "173647"))
        }
    }

    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholderColor: UIColor {
        get {
            return placeholderLabel.textColor
        }
        set{
            self.placeholderLabel.textColor = newValue
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            placeholderLabel.textColor = self.placeholderColor
            placeholderLabel.alpha = 1
            let width = frame.width - textContainer.lineFragmentPadding * 2
           // let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.sizeToFit()
            //placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.autoresizesSubviews = true
            placeholderLabel.autoresizingMask = [.flexibleWidth]
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            //for hide/unhide textview when user
            textStorage.delegate = self
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}


///attributed text of add images
extension UILabel {
    /// add imaeg after text
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }
    
    /// add image before text
    func addLeading(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: "  " + text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}

func changeTextColor(fullStr: String, str: String , color : UIColor) -> NSAttributedString
{
    let AttributeString = NSMutableAttributedString(string: fullStr)
    let range = (fullStr as NSString).range(of: str)
    AttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
    return AttributeString
}

struct Constant {
    
    //----------------------------------------------------------------
    //MARK:- KEY CONST -
    static let kStaticRadioOfCornerRadios:CGFloat = 0
    static let ALERT_OK                = "OK"
    static let ALERT_DISMISS           = "Dismiss"
    static let KEY_IS_USER_LOGGED_IN   = "USER_LOGGED_IN"
    
    
    
    static var APP_NAME:String {
        
        if let bundalDicrectory = Bundle.main.infoDictionary{
            return  bundalDicrectory[kCFBundleNameKey as String] as? String ?? "Aviation"
        } else {
            return "Aviation"
        }
        
    }
}

extension UIImageView {
    func setImageWithSDWEBImage(placeHolderImage: UIImage?, imgPath: String) {
       UIView.performWithoutAnimation {
           let imageNew = imgPath
           if let _ = URL(string: imageNew){
               let imgView = self 
               DispatchQueue.main.async {
                   var thumbnailSize = imgView.frame.size
                   thumbnailSize.width = thumbnailSize.width * UIScreen.main.scale
                   thumbnailSize.height = thumbnailSize.height * UIScreen.main.scale
                   SDImageCoderHelper.defaultScaleDownLimitBytes = UInt(imgView.frame.size.width * imgView.frame.size.height * 4)
                   let optins: SDWebImageOptions = [.retryFailed]
                   imgView.sd_imageTransition = .fade
                   imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                   imgView.sd_setImage(with: URL(string: imgPath), placeholderImage: placeHolderImage, options: optins, context: [.imageThumbnailPixelSize : thumbnailSize])
               }
               
           } else {
               DispatchQueue.main.async {
                   //                    imgView?.sd_imageTransition = .none
                   //                    imgView?.image = placeHolderImage
               }
           }
       }
   }

}

//MARK:- Debouncer Class
class Debouncer {
    var pendingRequestItem: DispatchWorkItem?
    
    func debounce(after delay: Double = 0.7, _ block: @escaping ()->Void) {
        self.cancel()
       
        let requestWorkItem = DispatchWorkItem(block: block)
        pendingRequestItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: requestWorkItem)
    }
    
    func cancel() {
        pendingRequestItem?.cancel()
    }
}

