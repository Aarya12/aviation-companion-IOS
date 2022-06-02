//
//  CustomTabbar.swift
//  Aviation
//
//  Created by Zestbrains on 30/07/21.
//

import Foundation
import UIKit

//MARK:- Custom tabbar with corners
@IBDesignable class TabBarWithCorners: UITabBar {
    @IBInspectable var color: UIColor?
    @IBInspectable var radii: CGFloat = 25.0

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
    
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        shapeLayer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOffset = CGSize(width: 2, height: -4)
        shapeLayer.shadowOpacity = 1
        shapeLayer.fillColor = color?.cgColor ?? UIColor.white.cgColor
        shapeLayer.lineWidth = 1
    
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
    
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))
    
        return path.cgPath
    }
}
