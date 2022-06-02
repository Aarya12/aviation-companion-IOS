//
//  ChangePasswordVC.swift
//  Aviation
//
//  Created by Zestbrains on 17/11/21.
//

import UIKit
import Toaster

class ChangePasswordVC : UIViewController {
    
    //MARK: - OUTLETS
        
    @IBOutlet weak var txtCurrentPassword: AppCommonTextField!
    
    @IBOutlet weak var txtNewPassword: AppCommonTextField!
    @IBOutlet weak var txtConfirmNewPassword: AppCommonTextField!

    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    
    //MARK: - VARIABLES
    private let changePasswordVM = ChangePasswordViewModel() 
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    @IBAction func btnSaveClicks(_ sender: Any) {
        self.addDataIntoModel()
        
        changePasswordVM.WSChangePassword { response in
            self.popTo()
        } failure: { errorResponse in
            //error
        }

    }
        
}

//MARK: - Data Fills in models
extension ChangePasswordVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        changePasswordVM.vc = self

        changePasswordVM.oldPassword = self.txtCurrentPassword.text ?? ""
        changePasswordVM.password = self.txtNewPassword.text ?? ""
        changePasswordVM.confirmPassword = self.txtConfirmNewPassword.text ?? ""
    }

}
