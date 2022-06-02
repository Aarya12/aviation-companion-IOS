//
//  ForgotPasswordVC.swift
//  Aviation
//
//  Created by Zestbrains on 10/11/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var txtEmail: AppCommonTextField!
        
    @IBOutlet weak var btnSend: EMButton! {
        didSet
        {
            btnSend.btnType = .Submit
        }
    }
    
    //MARK: - VARIABLES
    private let forgotPasswordViewModel = ForgotPasswordViewModel()

    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnSendClicks(_ sender: Any) {
        
        addDataIntoModel()

        forgotPasswordViewModel.WSForgotPassword { _ in
            self.pushTo("EmailConfirmationVC")
        } failure: { errorResponse in
            //failur
        }
        
    }
    
    @IBAction func btnLoginClicks(_ sender: Any) {
        
        self.popTo()
    }
    
    //MARK: - OTHER FUNCTIONS
}

//MARK: - Data Fills in models
extension ForgotPasswordVC {
    
    private func addDataIntoModel() {
        self.view.endEditing(true)
        forgotPasswordViewModel.vc = self

        forgotPasswordViewModel.email = self.txtEmail.text ?? ""
    }

}
