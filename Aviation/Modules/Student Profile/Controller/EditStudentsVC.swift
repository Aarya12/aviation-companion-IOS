//
//  EditStudentsVC.swift
//  Aviation
//
//  Created by Zestbrains on 18/11/21.
//

import UIKit
import SKCountryPicker
import IQKeyboardManagerSwift

class EditStudentsVC : UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var scrollMain: UIScrollView!

    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtName: AppCommonTextField!
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: AppCommonTextField!
    
    @IBOutlet weak var txtFTN: AppCommonTextField!
    
    @IBOutlet weak var txtCertificate: AppCommonPickerTextField!
    
    @IBOutlet weak var txtAviationLocations: AppCommonTextField!
    
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
    var isFromSidemenu : Bool = true

    var profileVM = ProfileViewModel()
    public var userID : String = ""

    private let certificateVM = CertificatesViewModel()
    private let aviationVM = AviationsViewModel.shared

    private let pickerCertificates : UIPickerView = UIPickerView()
    
    private let debounce = Debouncer()
    var didEditedProfile : ((ProfileViewModel) -> ())?
    
    var isFromFillRemainingData = false
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.isHidden = isFromFillRemainingData
        if isFromFillRemainingData {
            showAlertWithTitleFromVC(vc: self, andMessage: "You have to fill incomplete data to become a Student")
        }

        if isFromSidemenu {
            GetStudentProfile()
        }else {
            self.bindData()
        }

        setPickers()
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
        
        self.WSEditProfile()
    }
        
    @IBAction func btnProfilePickerClicks(_ sender: Any) {
        
        ImagePickerManager().pickImage(self) { img in
            self.imgProfile.image = img
            self.isImageChanged = true
        }
    }
    
    @IBAction func btnCountryPickerClicks(_ sender: Any) {

        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country) in
            self.lblCountryCode.text = country.dialingCode
        }
        
        countryController.detailColor = UIColor.black
    }
}

//MARK: - GENERAL METHODS
extension  EditStudentsVC {
    
    func setPickers() {
        
        pickerCertificates.dataSource = self
        pickerCertificates.delegate = self

        txtCertificate.delegate = self
        txtCertificate.inputView = pickerCertificates
        
        txtAviationLocations.delegate = self
    }
}

//MARK: - UITextFieldDelegate METHODS
extension  EditStudentsVC : UITextFieldDelegate , SelectAviationDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCertificate {
            if (textField.text ?? "").isEmpty {
                txtCertificate.text = certificateVM.arrCertificates.first?.name ?? ""
                profileVM.certificateID = certificateVM.arrCertificates.first?.id ?? 0
            }
        }else if textField == txtAviationLocations {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtAviationLocations {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtAviationLocations {
            
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
        
        txtAviationLocations.text = "\(avition.name ?? "") (\(avition.localCode ?? ""))"
        profileVM.HomeAirportID = avition.id ?? 0
    }

}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource METHODS
extension  EditStudentsVC : UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return certificateVM.arrCertificates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return certificateVM.arrCertificates[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtCertificate.text = certificateVM.arrCertificates[row].name
        profileVM.certificateID = certificateVM.arrCertificates[row].id
    }
}


//MARK: - APIs CAll
extension  EditStudentsVC {
    
    private func GetStudentProfile() {
        
        viewScreenData.isHidden = true

        profileVM.userID = AviationUser.shared.id.integerValue
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
            
            txtAviationLocations.text = user.airport.name
            profileVM.HomeAirportID = user.airportId
            txtName.text = user.name
            txtEmail.text = user.email
            
            txtPhoneNumber.text = user.mobile
            txtFTN.text = user.ftn
            txtCertificate.text = user.certificates?.name ?? ""
            profileVM.certificateID = user.certificates?.id ?? 0
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

//MARK: - Data Fills in models
extension EditStudentsVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        
        profileVM.vc = self
        
        profileVM.name = txtName.text ?? ""
        profileVM.email = self.txtEmail.text ?? ""
        
        profileVM.countryCode = lblCountryCode.text!
        
        profileVM.mobile = txtPhoneNumber.text ?? ""
        
        profileVM.FTN = txtFTN.text ?? ""
        
        profileVM.profileImgData = (isImageChanged ? self.imgProfile.image?.pngData() : nil)
    }
}
