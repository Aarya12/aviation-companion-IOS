//
//  EditProfileVC.swift
//  Aviation
//
//  Created by Zestbrains on 16/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class EditProfileVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var scrollMain: UIScrollView!

    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtName: AppCommonTextField!
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
    
    @IBOutlet weak var txtAirport: AppCommonTextField!
    
    @IBOutlet weak var txtExperiance: AppCommonTextField!
    
    @IBOutlet weak var txtApproxHours: AppCommonPickerTextField!
    
    @IBOutlet weak var txtBackStory: AppCommonTextField!
    
    @IBOutlet weak var txtPrice: AppCommonTextField!
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    @IBOutlet weak var aviationList: AviationLVW! {
        didSet {
            self.aviationList.delegate = self
            aviationVM.getNearByAirports(self) { arr in
                self.aviationList.arrAviations = arr
            }
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!

    
    //MARK: - VARIABLES
    var isImageChanged : Bool = false
    let pickerHours : UIPickerView = UIPickerView()
    
    private let debounce = Debouncer()
    public var profileVM = ProfileViewModel()
    private let aviationVM = AviationsViewModel.shared
    
    var isFromSidemenu : Bool = true
    var didEditedProfile : ((ProfileViewModel) -> ())?

    var isFromFillRemainingData = false

    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.isHidden = isFromFillRemainingData
        if isFromFillRemainingData {
            showAlertWithTitleFromVC(vc: self, andMessage: "You have to fill incomplete data to become an Instructor")
        }
        
        setPickers()
        
        if isFromSidemenu {
            self.getCurrentUserProfile()
        }else {
            self.bindData()
        }
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
        self.addDataIntoModel()
        
        WSEditProfile()
    }
    
    @IBAction func btnProfilePickerClicks(_ sender: Any) {
        ImagePickerManager().pickImage(self) { img in
            self.imgProfile.image = img
            self.isImageChanged = true
        }
    }
}

//MARK: - GENERAL METHODS
extension  EditProfileVC {
    
    func setPickers() {
        pickerHours.dataSource = self
        pickerHours.delegate = self
        
        txtApproxHours.delegate = self
        txtApproxHours.inputView = pickerHours
    }
}

//MARK: - UITextFieldDelegate & SelectAviationDelegate
extension  EditProfileVC : SelectAviationDelegate, UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtApproxHours {
            if textField.text!.isEmpty {
                textField.text = arrHours.first ?? ""
                profileVM.approxHours = arrHours.first ?? ""
            }
        }else if textField == txtAirport {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAirport {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtAirport {
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString =
            currentString.replacingCharacters(in: range, with: string)
            
            let filterArr =  aviationVM.arrAviations.filter({($0.name.localizedCaseInsensitiveContains(newString)) || ($0.localCode.localizedCaseInsensitiveContains(newString))})
            aviationList.arrAviations = filterArr
            
            var rect = textField.superview?.convert(textField.frame, to: scrollMain) ?? .zero
            rect.size.height = textField.frame.size.height + ((filterArr.count == 0) ? 0 : aviationList.frame.size.height) + 35
            self.scrollMain.scrollRectToVisible(rect, animated: true)

        }

        return true
    }

    func didSelectAviation(avition: ModelProfileAirport) {
        self.view.endEditing(true)
        
        aviationList.isHidden = true
        
        txtAirport.text = "\(avition.name ?? "") (\(avition.localCode ?? ""))"
        profileVM.airPortID = avition.id ?? 0
    }
    
}



//MARK: - UIPickerViewDelegate, UIPickerViewDataSource METHODS
extension  EditProfileVC : UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrHours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrHours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtApproxHours.text = arrHours[row]
    }
}


//MARK: - Data Fills in models
extension EditProfileVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        
        profileVM.vc = self
        
        profileVM.name = txtName.text ?? ""
        profileVM.email = self.txtEmail.text ?? ""
        
        profileVM.approxHours = txtApproxHours.text ?? ""
        
        profileVM.experience_in_year = txtExperiance.text ?? ""
        
        profileVM.ratePerHour = txtPrice.text ?? ""
        
        profileVM.backStory = txtBackStory.text ?? ""
        profileVM.profileImgData = (isImageChanged ? self.imgProfile.image?.pngData() : nil)
    }
}

//MARK: - API calls
extension  EditProfileVC {
    
    private func getCurrentUserProfile() {
        viewScreenData.isHidden = true

        profileVM.userID = AviationUser.shared.id.integerValue
        
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
            profileVM.airPortID = user.airport?.id ?? 0
            txtEmail.text = user.email
            
            txtExperiance.text = user.experienceInYear
            txtApproxHours.text = user.approxHours
            txtBackStory.text = user.backStory
            txtPrice.text = user.ratePerHour
        }
    }
    
    func WSEditProfile() {
        profileVM.WSEditProfile { _ in
            self.didEditedProfile?(self.profileVM)
            if self.isFromFillRemainingData {
                appDelegate.setHomeScreen()
            }else {
                self.popTo()
            }
        } failure: { errorResponse in
            //failur
        }
    }
}
