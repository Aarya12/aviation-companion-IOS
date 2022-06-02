//
//  EmailConfirmationVC.swift
//  Aviation
//
//  Created by Zestbrains on 10/11/21.
//

import UIKit

class EmailConfirmationVC: UIViewController {
    
    //MARK: - OUTLETS
            
    @IBOutlet weak var btnSend: EMButton! {
        didSet
        {
            btnSend.btnType = .Submit
        }
    }
    
    //MARK: - VARIABLES
    
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnOkClicks(_ sender: Any) {
        appDelegate.setLoginScreen()
    }
        
}
