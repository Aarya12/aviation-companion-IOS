//
//  InstructorsCVC.swift
//  Aviation
//
//  Created by Zestbrains on 17/12/21.
//

import UIKit

class InstructorsCVC: UICollectionViewCell {

    @IBOutlet weak var viewMainBG: UIView! {
        didSet {
            viewMainBG.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor, shadowOffset: CGSize(width: 0, height: 8), shadowOpacity: 1, shadowRadius: 8)
        }
    }
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblRatePerHour: UILabel!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblExperience: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    //MARK: - Cell methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

//MARK: - GENERAL METHODS
extension  InstructorsCVC {
    
    func bindData(obj : ModelInstructorMain) {
        
        imgProfile.kf.indicatorType = .activity
        imgProfile.kf.setImage(with: URL(string: obj.profileImage ?? ""), placeholder: UIImage(named: "ic_user_placeholder"), options: nil, completionHandler: nil)
        lblRatePerHour.text = (obj.ratePerHour ?? "").blankManage(newStr: "0")

        lblInstructorName.text = (obj.name ?? "").blankManage()
        lblEmail.text = (obj.email ?? "").blankManage()

        lblExperience.text = "\((obj.experienceInYear ?? "").blankManage(newStr: "0")) Yr"
        lblLocation.text = (obj.airport?.name ?? "").blankManage()
    }
}

