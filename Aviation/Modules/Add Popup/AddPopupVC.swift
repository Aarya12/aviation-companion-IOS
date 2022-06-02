//
//  AddPopupVC.swift
//  Aviation
//
//  Created by Zestbrains on 15/11/21.
//

import UIKit

class AddPopupVC: UIViewController {
    
    //MARK: - OUTLETS
    
    
    //MARK: - VARIABLES
    
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnOverlayClicks(_ sender: Any) {
        
        self.dismiss(animated: true)
    }

    @IBAction func btnAddStudentsClicks(_ sender: Any) {
        print("btnAddStudentsClicks")
        self.dismiss(animated: true) {

            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AddStudentPopupVC") as! AddStudentPopupVC
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }

        }
    }
    

    @IBAction func btnAddEventsClicks(_ sender: Any) {
        print("btnAddEventsClicks")
        self.dismiss(animated: true) {
            
            let vc = storyBoards.Event.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
}
