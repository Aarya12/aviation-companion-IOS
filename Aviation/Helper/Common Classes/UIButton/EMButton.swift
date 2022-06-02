//
//  EMButton.swift
//  Aviation
//
//  Created by Mac on 06/11/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//


import UIKit

enum buttonType {
    case normal
    case Submit
    case SubmitWithoutShadow
}

class EMButton: UIButton {
    
    var btnType:buttonType = .normal
    //INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit()
    {
        self.titleLabel?.font = fontSemiBold22
        self.isExclusiveTouch = true
        switch btnType {
        case .normal:
            self.layer.cornerRadius = 0
            self.clipsToBounds = true
    
            break
        case .Submit:
            self.backgroundColor = .appColor
            self.titleLabel?.font = Font(.installed(.Bold), size: .custom((IS_IPAD_DEVICE() ? 22.0 : 18.0))).instance
            
            self.layer.cornerRadius = 10
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.white, for: .selected)
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0

            self.clipsToBounds = false

        case .SubmitWithoutShadow :
            self.backgroundColor = .appColor
            self.titleLabel?.font = Font(.installed(.SemiBold), size: .custom(16.0)).instance
            
            self.Round = true
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.white, for: .selected)
            self.layer.masksToBounds = false
            self.layer.borderWidth = 0
            //background: 101,180,246,1;

            self.clipsToBounds = true
        }
    }
    
}

