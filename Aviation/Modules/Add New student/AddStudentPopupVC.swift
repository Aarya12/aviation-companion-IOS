//
//  AddStudentPopupVC.swift
//  Aviation
//
//  Created by Zestbrains on 09/12/21.
//

import UIKit
import BottomPopup

class AddStudentPopupVC  : BottomPopupViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtName: AppCommonTextField!
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
    
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var txtCertificate: AppCommonPickerTextField!
    @IBOutlet weak var btnAddNow: EMButton! {
        didSet {
            btnAddNow.btnType = .Submit
        }
    }
    
    //MARK: - VARIABLES
    private let addStudentVM = AddStudentViewModel()
    private let certificateVM = CertificatesViewModel()
    private var pickerCertificates = UIPickerView()
    
    //BOTTOM VIEW
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPickers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updatePopupHeight(to: ScreenSize.HEIGHT)
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        
        var rect = UIScreen.main.bounds
        rect.origin.y = UIScreen.main.bounds.height + 1000
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        scrollView.scrollsToTop = true
    }
    
    // MARK: - BottomPopupAttributesDelegate Variables
    override var popupHeight: CGFloat { height ?? ScreenSize.HEIGHT }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 15.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.5 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.5 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { 0.5 }
    
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnDismissClicks(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAddNowClicks(_ sender: Any) {
        
        self.fillVMModels()
        
        self.AddStudent()
    }
}

//MARK: - GENERAL METHODS
extension AddStudentPopupVC {
    
    private func setPickers() {
        txtCertificate.delegate = self
        
        pickerCertificates.delegate = self
        pickerCertificates.dataSource = self
        txtCertificate.inputView = pickerCertificates
    }
    
    private func fillVMModels() {
        addStudentVM.vc = self
        
        addStudentVM.name = txtName.text!
        addStudentVM.email = txtEmail.text!
    }
}

//MARK: - UITextFieldDelegate & SelectAviationDelegate
extension  AddStudentPopupVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtCertificate {
            if textField.text!.isEmpty {
                textField.text = certificateVM.arrCertificates.first?.name ?? ""
                addStudentVM.certificateID = certificateVM.arrCertificates.first?.id ?? 0
            }
        }
    }
    
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension  AddStudentPopupVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return certificateVM.arrCertificates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return certificateVM.arrCertificates[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtCertificate.text = certificateVM.arrCertificates[row].name ?? ""
        addStudentVM.certificateID = certificateVM.arrCertificates[row].id
    }
}

//MARK: - APIs
extension  AddStudentPopupVC {
        
    func AddStudent() {
        addStudentVM.AddStudentAPI { _ in
            self.dismiss(animated: true) {
                if let topVC = UIApplication.topViewController() as? AllStudentsVC {
                    
                    //reload all students
                    topVC.setupInitialData()
                    
                    print("AllStudentsVC")
                }else {
                    let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AllStudentsVC") as! AllStudentsVC
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }

        } failure: { errorResponse in
            
        }
    }

}
