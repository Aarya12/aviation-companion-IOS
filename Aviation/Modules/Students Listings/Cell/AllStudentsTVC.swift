//
//  AllStudentsTVC.swift
//  Aviation
//
//  Created by Zestbrains on 17/11/21.
//

import UIKit
import Kingfisher

class AllStudentsTVC: UITableViewCell {

    //MARK: - IBOUTLETS
    
    @IBOutlet weak var viewImgBG: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblStudentName: UILabel!
    
    @IBOutlet weak var lblStudentEmail: UILabel!
    
    @IBOutlet weak var lblStudentNotes: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    
    @IBOutlet weak var btnViewNotes: UIButton!
    
    @IBOutlet weak var btnStudentProfile: UIButton!
    
    //MARK: - variables
    var btnCloser : buttonActionAlias?
    
    //MARK: - cell functions
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewImgBG.Round = true
            self.imgProfile.Round = true
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnClicks(_ sender: UIButton) {
        
        btnCloser?(sender)
    }
    
}

//MARK: - AllStudents data
extension  AllStudentsTVC {
        
    func bindData(obj : ModelStudents , isForAllStudnets : Bool = true) {
        imgProfile.kf.indicatorType = .activity
        imgProfile.kf.setImage(with: URL(string: obj.profileImage ?? ""), placeholder: nil, options: nil, completionHandler: nil)
        
        lblStudentName.text = obj.name
        lblStudentEmail.text = obj.email
        btnAdd.setTitle("Add", for: .normal)
        btnAdd.setTitle("Added", for: .selected)
        
        btnAdd.isSelected = obj.isAlreadyStudent.boolValue
        
        if isForAllStudnets {
            btnAdd.isHidden = false
            btnViewNotes.isHidden = true
            btnViewProfile.isHidden = true
            lblStudentNotes.isHidden = true
        }
        
        lblStudentNotes.text = "\(obj.total_notes ?? 0) Notes"
    }
}

