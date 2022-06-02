//
//  ProfileVC.swift
//  Aviation
//
//  Created by Zestbrains on 16/11/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }

    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtName: AppCommonTextField!
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
    
    @IBOutlet weak var viewAirport: UIView!
    @IBOutlet weak var txtAirport: AppCommonTextField!
    
    @IBOutlet weak var txtExperience: AppCommonTextField!
    
    @IBOutlet weak var txtApproxHours: AppCommonTextField!
    
    @IBOutlet weak var txtBackStory: AppCommonTextField!
    
    @IBOutlet weak var txtRatePerHour: AppCommonTextField!
    
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var stackOtherDetails: UIStackView!
    
    //MARK: - VARIABLES
    private var profileVM = ProfileViewModel()
    var instructurId : Int = AviationUser.shared.id.integerValue
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialData()
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
    
    @IBAction func btnEditProfileClicks(_ sender: Any) {
        let vc = storyBoards.Home.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.isFromSidemenu = false
        vc.profileVM = self.profileVM
        vc.didEditedProfile = { obj in
            self.profileVM = obj
            self.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChangePasswordClicks(_ sender: Any) {
        self.pushTo("ChangePasswordVC")
    }
}


//MARK: - GENERAL METHODS
extension  ProfileVC {
    
    private func setInitialData() {
        
        lblHeaderTitle.text = "Profile"

        btnEditProfile.isHidden = (AppSelectedUserType == .Student)

        viewScreenData.isHidden = true
        if AppSelectedUserType == .Instructor {
            //profileVM.userID = self.instructurId

        }else {
            //get Other user profile
            
        }
        profileVM.userID = self.instructurId

        self.getCurrentUserProfile()
    }
    
}

//MARK: - API CALLS
extension  ProfileVC {
    
    private func getCurrentUserProfile() {
                
        profileVM.WSGetProfileDetails { response in
            
            self.bindData()
            
        } failure: { errorResponse in
            //
        }
    }
    
    private func bindData() {
        
        viewScreenData.isHidden = false
        
        if let user = self.profileVM.profileModel {
            imgProfile.kf.indicatorType = .activity
            imgProfile.kf.setImage(with: URL(string: user.profileImage), placeholder: UIImage(named: ""), options: nil, completionHandler: nil)
            
            txtName.text = user.name
            txtAirport.text = user.airport?.name ?? ""
            txtEmail.text = user.email
            
            txtExperience.text = user.experienceInYear
            txtApproxHours.text = user.approxHours
            txtBackStory.text = user.backStory
            txtRatePerHour.text = user.ratePerHour
        }
    }
}
