//
//  TagsCVC.swift
//  Aviation
//
//  Created by Zestbrains on 19/11/21.
//

import UIKit

class TagsCVC: UICollectionViewCell {

    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var viewTagsBG: UIView!
    
    
    //MARK: - variables
    var deleteCloser : buttonActionAlias?
    
    var isShowRemoveBtn : Bool = false {
        didSet {
            btnDelete.isHidden = !isShowRemoveBtn
        }
    }
    
    //MARK: - Cell functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewTagsBG.Round = true
        })
    }
    
    //MARK: - BUTTON action
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        self.deleteCloser?(sender)
    }
}
