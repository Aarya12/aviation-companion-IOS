//
//  StudentProfileVC.swift
//  Aviation
//
//  Created by Zestbrains on 18/11/21.
//

import UIKit

class StudentProfileVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalNotes: UILabel!


    @IBOutlet weak var lblAviationLocations: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblFTN: UILabel!
    
    @IBOutlet weak var lblCertificate: UILabel!
    @IBOutlet weak var lblTotalHours: UILabel!

    
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var viewTotalNotes: UIView!
    
    //MARK: - VARIABLES
    private var profileVM = ProfileViewModel()
    public var userID : String = ""
        
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitialData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.imgProfile.Round = true
            self.viewImgBG.Round = true
        }
    }

    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    @IBAction func btnSaveClicks(_ sender: Any) {
        let vc = storyBoards.Student.instantiateViewController(withIdentifier: "EditStudentsVC") as! EditStudentsVC
        vc.isFromSidemenu = false
        vc.profileVM = self.profileVM
        vc.didEditedProfile = { obj in
            self.profileVM = obj
            self.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
        
}

//MARK: - GENERAL METHODS
extension  StudentProfileVC {
    
    func setInitialData() {
        
        lblHeaderTitle.text = (AppSelectedUserType == .Student) ? "My Profile" : "Student Profile"
        btnEditProfile.isHidden = (AppSelectedUserType != .Student)
        
        viewScreenData.isHidden = true

        if AppSelectedUserType == .Student {
            self.userID = AviationUser.shared.id
        }
        
        profileVM.userID = self.userID.integerValue
        self.GetStudentProfile()
    }
    
}

//MARK: - APIs CAll
extension  StudentProfileVC {
    
    private func GetStudentProfile() {
        viewScreenData.isHidden = true

        profileVM.WSGetProfileDetails { response in
            
            self.bindData()
            
        } failure: { errorResponse in
            //failur
        }
    }
    
    //binding user data
    private func bindData() {
        
        viewScreenData.isHidden = false
        
        if let user = self.profileVM.profileModel {
            imgProfile.kf.indicatorType = .activity
            imgProfile.kf.setImage(with: URL(string: user.profileImage), placeholder: UIImage(named: ""), options: nil, completionHandler: nil)
            
            lblAviationLocations.text = user.airport?.name
            lblName.text = user.name
            lblEmail.text = user.email
            
            lblPhoneNumber.text = user.mobile
            lblFTN.text = user.ftn
            lblCertificate.text = user.certificates.name
            
            lblTotalNotes.isHidden = (AppSelectedUserType == .Student)
            lblTotalNotes.text = "\(user.totalNotes ?? 0) Notes"
            

            viewTotalNotes.isHidden = (AppSelectedUserType == .Student)
            lblTotalHours.text = user.totalHours
        }
    }

}
