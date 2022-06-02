//
//  HomeNotesCVC.swift
//  Aviation
//
//  Created by Zestbrains on 12/11/21.
//

import UIKit

class HomeNotesCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewMainBG: UIView!
    
    @IBOutlet weak var viewImageBG: UIView!

    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblNotesCount: UILabel!
    
    @IBOutlet weak var viewCertificate: UIView!
    
    @IBOutlet weak var lblCertificate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.imgProfile.Round = true
            self.viewImageBG.Round = true
        }
    }

}

//MARK: - AllStudents data
extension  HomeNotesCVC {
        
    func bindData(obj : ModelHomeUser) {
        
        if AppSelectedUserType == .Student {
            viewCertificate.isHidden = true
        }else {
            viewCertificate.isHidden = false
        }

        guard let userObj = obj.user else { return }
        
        imgProfile.kf.indicatorType = .activity
        imgProfile.kf.setImage(with: URL(string: userObj.profileImage ?? ""), placeholder: nil, options: nil, completionHandler: nil)
        
        lblUserName.text = userObj.name
        
        lblNotesCount.text = "\(userObj.totalNotes ?? 0) Notes"
        
        lblCertificate.text = userObj.certificates?.name ?? ""
    }
}

