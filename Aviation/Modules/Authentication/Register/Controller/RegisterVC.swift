//
//  RegisterVC.swift
//  Aviation
//
//  Created by Zestbrains on 10/11/21.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class RegisterVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var scrollMain: UIScrollView!
    @IBOutlet weak var txtName: AppCommonTextField!
    @IBOutlet weak var txtEmail: AppCommonTextField!
    
    @IBOutlet weak var txtPassword: AppCommonTextField!
    
    @IBOutlet weak var txtConfirmPassword: AppCommonTextField!
    
    @IBOutlet weak var btnRegister: EMButton! {
        didSet
        {
            btnRegister.btnType = .Submit
        }
    }
    
    @IBOutlet var viewUserTypes: [BGViewForTextFields]!
    
    @IBOutlet var viewUserSelectionStatus: [UIView]!
    
    @IBOutlet var lblUserTypes: [UILabel]!
    
    @IBOutlet weak var stackInstructorOtherDetails: UIStackView!
    
    @IBOutlet weak var txtInstructorExperiance: AppCommonTextField!
    
    @IBOutlet weak var txtInstructorApproxHours: AppCommonPickerTextField!
    @IBOutlet weak var txtInstructorRates: AppCommonTextField!
    @IBOutlet weak var txtInstructorLocation: AppCommonTextField!

    @IBOutlet weak var stackHoursExperianceRate: UIStackView!
    
    @IBOutlet weak var stackStudentOtherDetails: UIStackView!
    @IBOutlet weak var txtCertificate: AppCommonPickerTextField!
    
    @IBOutlet var btnRoles: [UIButton]!
    //@IBOutlet weak var viewAirports: UIView!
    @IBOutlet weak var aviationList: AviationLVW! {
        didSet {
            self.aviationList.delegate = self
            aviationVM.getNearByAirports(self) { arr in
                self.aviationList.arrAviations = arr
            }
        }
    }
    
    @IBOutlet var viewPasswords: [BGViewForTextFields]! {
        didSet {
            viewPasswords.forEach({$0.isHidden = self.isFromSocialRegister})
        }
    }
    //MARK: - VARIABLES
    let debounce = Debouncer()
    private var registerViewModel = RegisterViewModel()
    
    private let certificateVM = CertificatesViewModel()
    private let aviationVM = AviationsViewModel.shared
    
    //private var arrCertificates : [AviationCertificateModel] = []
    private var pickerCertificates = UIPickerView()
    private var pickerHours = UIPickerView()

    public var socialRegisterDict : [String : Any] = [:]
    var isFromSocialRegister : Bool = false
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPickers()
        
        PreFillSocialData()
        
        self.btnUserTypeSelection(btnRoles[1])
        
        
        registerViewModel.vc = self

        txtInstructorLocation.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if IS_IPAD_DEVICE() {
            stackHoursExperianceRate.axis = .horizontal
        }else {
            stackHoursExperianceRate.axis = .vertical
        }
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnRegisterClicks(_ sender: Any) {
        self.addDataIntoModel()
        
        if isFromSocialRegister {
            
            registerViewModel.SocialRegisterAPI { _ in
                appDelegate.setHomeScreen()
            } failure: { errorResponse in
                //failur
            }

        }else {

            registerViewModel.RegisterAPI { _ in
                appDelegate.setHomeScreen()
            } failure: { errorResponse in
                //failur
            }

        }
        
    }
    
    @IBAction func btnLoginClicks(_ sender: Any) {
        
        self.popTo()
    }
    
    @IBAction func btnUserTypeSelection(_ sender: UIButton) {
        
        viewUserTypes.forEach({$0.borderColor = .clear})

        lblUserTypes.forEach({$0.textColor = hexStringToUIColor(hex: "#ACACAC")})

        viewUserSelectionStatus.forEach({$0.backgroundColor = hexStringToUIColor(hex: "#DEDEDE")})

        stackInstructorOtherDetails.isHidden = (sender.tag == 0)
        
        stackStudentOtherDetails.isHidden = (sender.tag != 0)
        
        viewUserTypes[sender.tag].borderColor = .appColor

        if sender.tag == 0 {
            AppSelectedUserType = .Student
        }else {
            AppSelectedUserType = .Instructor
        }
        
        lblUserTypes[sender.tag].textColor = .black
        viewUserSelectionStatus[sender.tag].backgroundColor = .appColor
    }
    
    //MARK: - OTHER FUNCTIONS
    
}

//MARK: - GENERAL METHODS
extension  RegisterVC {
    
    func setPickers() {
        txtCertificate.delegate = self
        
        pickerCertificates.delegate = self
        pickerCertificates.dataSource = self
        txtCertificate.inputView = pickerCertificates
        
        
        //Approx Hours
        txtInstructorApproxHours.delegate = self
        
        pickerHours.dataSource = self
        pickerHours.delegate = self
        txtInstructorApproxHours.inputView = pickerHours
    }
}


//MARK: - UITextFieldDelegate & SelectAviationDelegate
extension  RegisterVC : SelectAviationDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtInstructorLocation {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtCertificate {
            if textField.text!.isEmpty {
                textField.text = certificateVM.arrCertificates.first?.name ?? ""
                registerViewModel.certificateID = certificateVM.arrCertificates.first?.id ?? 0
            }
        }else if textField == txtInstructorApproxHours {
            if textField.text!.isEmpty {
                textField.text = arrHours.first ?? ""
                registerViewModel.approxHours = arrHours.first ?? ""
            }
        }else if textField == txtInstructorLocation {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtInstructorLocation {
            
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
        
        txtInstructorLocation.text = "\(avition.name ?? "") (\(avition.localCode ?? ""))"
        registerViewModel.airPortID = avition.id ?? 0
    }

}

//MARK: - Data Fills in models
extension RegisterVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        
        registerViewModel.vc = self
        
        registerViewModel.name = txtName.text ?? ""
        registerViewModel.email = self.txtEmail.text ?? ""
        registerViewModel.password = self.txtPassword.text ?? ""
        registerViewModel.confirmPassword = self.txtConfirmPassword.text ?? ""
        
        registerViewModel.approxHours = txtInstructorApproxHours.text ?? ""
        
        registerViewModel.experience_in_year = txtInstructorExperiance.text ?? ""
        
        registerViewModel.ratePerHour = txtInstructorRates.text ?? ""
    }

    private func PreFillSocialData() {
        guard isFromSocialRegister else { return }
        
        let json = JSON(self.socialRegisterDict)
        
        txtName.text = json[kName].stringValue
        txtEmail.text = json[kemail].stringValue
        
        registerViewModel.email = json[kemail].stringValue
        registerViewModel.name = json[kName].stringValue
        registerViewModel.socialParams = self.socialRegisterDict
    }
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension  RegisterVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerHours {
            return arrHours.count
        }else {
            return certificateVM.arrCertificates.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerHours {
            return arrHours[row]
        }else {
            return certificateVM.arrCertificates[row].name ?? ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerHours {
            txtInstructorApproxHours.text = arrHours[row]
            registerViewModel.approxHours = arrHours[row]
        }else {
            txtCertificate.text = certificateVM.arrCertificates[row].name ?? ""
            registerViewModel.certificateID = row
        }
    }
}

