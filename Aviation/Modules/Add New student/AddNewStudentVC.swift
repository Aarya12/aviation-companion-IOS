//
//  AddNewStudentVC.swift
//  Aviation
//
//  Created by Zestbrains on 17/11/21.
//

import UIKit

class AddNewStudentVC : UIViewController {
    
    //MARK: - OUTLETS
    
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
    
    
    //MARK: - VARIABLES
    var isImageChanged : Bool = false
    
    var arrCertificates : [String] = ["Certificate 1" , "Certificate 2", "Certificate 3", "Certificate 4", "Certificate 5", "Certificate 6", "Certificate 7", "Certificate 8", "Certificate 9", "Certificate 10", "Certificate 11", "Certificate 12", "Certificate 13"]
    
    let pickerCertificates : UIPickerView = UIPickerView()
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
        
    @IBAction func btnProfilePickerClicks(_ sender: Any) {
        
        ImagePickerManager().pickImage(self) { img in
            self.imgProfile.image = img
            self.isImageChanged = true
        }
    }
    
    @IBAction func btnCountryPickerClicks(_ sender: Any) {
        
    }
}

//MARK: - GENERAL METHODS
extension  AddNewStudentVC {
    
    func setPickers() {
        
        pickerCertificates.dataSource = self
        pickerCertificates.delegate = self

        txtCertificate.delegate = self
        txtCertificate.inputView = pickerCertificates
    }
}

//MARK: - UITextFieldDelegate METHODS
extension  AddNewStudentVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtCertificate {
            if (textField.text ?? "").isEmpty {
                txtCertificate.text = arrCertificates.first ?? ""
            }
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource METHODS
extension  AddNewStudentVC : UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCertificates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrCertificates[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtCertificate.text = arrCertificates[row]
    }
}
