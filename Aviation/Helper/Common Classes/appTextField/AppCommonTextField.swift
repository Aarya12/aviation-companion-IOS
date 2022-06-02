//
//  AppCommonTextField.swift
//  Aviation
//
//  Created by Zestbrains on 15/04/21.
//

import UIKit
import SkyFloatingLabelTextField

class BGViewForTextFields: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupTextField()
    }
    
    func setupTextField() {
        
        self.backgroundColor = .white
        
        self.cornerRadius = 10
        self.shadowForTextFields = true
    }
     
}


//NOTE : Please use the pickup the SkyFloatingLabelTextField file from this project because of the proper spacing issues
class AppCommonTextField: SkyFloatingLabelTextField {
    
    @IBInspectable public var xibChangeColorOfStr: String? {
        get { return "" }
        set(key) {
            self.attributedPlaceholder = changeTextColors(fullStr: self.placeholder ?? "", str: key ?? "", color1:  hexStringToUIColor(hex: "#2C2929"), color2: hexStringToUIColor(hex: "#B2B2B2"))
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupTextField()
    }
    
    private func setupTextField() {
        
        self.font = Font(.installed(.SemiBold), size: .custom((IS_IPAD_DEVICE() ? 19.0 : 17.0))).instance
        
        self.titleFont = Font(.installed(.Medium), size: .custom((IS_IPAD_DEVICE() ? 16.0 : 13.0))).instance
        self.textColor = .black
        self.placeHolderColor = hexStringToUIColor(hex: "#ACACAC")

        selectedLineHeight = 0
        lineHeight = 0
        
        selectedLineColor = .clear
        selectedTitleColor = .black
        
        lineColor = UIColor.clear
        titleColor = hexStringToUIColor(hex: "#ACACAC")
        
        self.autocorrectionType = .no
//        if let str = xibChangeColorOfStr {
//            //print("xibChangeColorOfStr" , str)
//        }
        
        self.backgroundColor = .clear
        
        
        self.addTarget(self, action: #selector(self.returnPressed(_:)), for: .editingDidEndOnExit)
    }
 
    @objc private func returnPressed(_ textField: UITextField) {
        self.resignFirstResponder()
    }
    
}

class AppCommonPickerTextField: AppCommonTextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tintColor = .clear
    }

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}


//MARK: - Texfield for the padding
class PaddingTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y + paddingTop , width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height - paddingTop - paddingBottom)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
