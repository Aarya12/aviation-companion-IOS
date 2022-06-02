//
//  UIView+Extensions.swift
//  Aviation
//
//  Created by Zestbrains on 09/11/21.
//

import Foundation
import UIKit

//MARK :- extended IBINSPECTABLE VARIABLEs
extension UIView {
    
    //MARK: - IBInspectable
    
    //Set Corner Radious
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor, shadowOffset: CGSize(width: 0, height: 4), shadowOpacity: 1, shadowRadius: 8)
            }
        }
    }
    
    @IBInspectable var SmallShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall()
            }
        }
    }

    @IBInspectable var ShadowForProfileImg: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.Round = true
                self.addShadowSmall(shadowColor: UIColor(red: 0.157, green: 0.776, blue: 0.776, alpha: 0.74).cgColor, shadowOffset: CGSize(width: 0, height: 4), shadowOpacity: 1, shadowRadius: 5)
            }
        }
    }

    //shadow changes =
    @IBInspectable var shadowForTextFields: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.clipsToBounds = false
                layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
                layer.shadowOpacity = 1
                layer.shadowRadius = 8
                layer.shadowOffset = CGSize(width: 0, height: 4)
            }
        }
    }
    
    @IBInspectable var isAddGradient : Bool {
        get {
            return self.isAddGradient
        }
        set {
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.addGradient()
                }
            }
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
}

//MARK: - Shadow

extension UIView {
    
    func  addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                    shadowOffset: CGSize = CGSize.zero,
                    shadowOpacity: Float = 0.5,
                    shadowRadius: CGFloat = 2.8) {
        //layer.cornerRadius = self.cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func  addTextFieldShadow(shadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor,
                    shadowOffset: CGSize = CGSize(width: 0, height: 4),
                    shadowOpacity: Float = 1,
                    shadowRadius: CGFloat = 8) {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

    
    func addShadowSmall(shadowColor: CGColor = UIColor.black.cgColor,
                        shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                        shadowOpacity: Float = 0.2,
                        shadowRadius: CGFloat = 2.0) {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor = .black, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

//MARK: - Round Some corners
extension UIView {
    /// to add round corner and autoupdate when the view's frame change
    ///
    /// - Parameter corners:
    /// for topLeft - layerMinXMinYCorner,
    /// for topRight - layerMaxXMinYCorner,
    /// for bottomLeft - layerMinXMaxYCorner,
    /// for bottomRight - layerMaxXMaxYCorner,
    ///
    func roundCornersWithMask(corners:CACornerMask, radius: CGFloat) {
        //self.clipsToBounds = false
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    
    func shadowWithMaskedCorner(corners:CACornerMask, radius: CGFloat,
                                shadowColor: CGColor = UIColor.darkGray.cgColor,
                                shadowOffset: CGSize = CGSize.zero,
                                shadowOpacity: Float = 0.5,
                                shadowRadius: CGFloat = 2.8) {
        //self.clipsToBounds = false
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}

extension CACornerMask {
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
}


//MARK: - ANIMATIONS
extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.2, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.2, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
}

//MARK: - GRADIENT
extension UIView {
    
    func addGradient() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.808, green: 0.604, blue: 0.337, alpha: 1).cgColor,
            UIColor(red: 0.91, green: 0.718, blue: 0.463, alpha: 1).cgColor
        ]
        
        self.layer.sublayers?.forEach({ (lyer) in
            if lyer.isKind(of: CAGradientLayer.self) {
                lyer.removeFromSuperlayer()
            }
        })
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.frame = self.bounds
        layer0.cornerRadius = self.cornerRadius
        if self.layer.sublayers?.count != 0 {
            self.layer.insertSublayer(layer0, at: 0)
        }else {
            self.layer.addSublayer(layer0)
        }
    }
    
}


