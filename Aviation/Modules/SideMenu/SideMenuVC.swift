//
//  SideMenuVC.swift
//  Aviation
//
//  Created by Zestbrains on 15/11/21.
//

import UIKit
import SideMenu
import Kingfisher

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var viewMainBG: UIView!
    @IBOutlet weak var viewUserProfile: UIView!
    
    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var tblSideMenu: UITableView!
    
    @IBOutlet weak var switchBecomeStudent: UISwitch!
    
    @IBOutlet weak var lblBecome: UILabel!
    
    //MARK: - VARIABLES
    var arrMenus : [Menu] = []
    
    struct Menu {
        var name : String = ""
        var image : UIImage = UIImage()
    }
    
    private let sidemenuViewModel = SideMenuViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSideMenu.registerCell(type: SideMenuTVC.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.imgProfilePicture.Round = true
            self.viewImgBG.Round = true
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setInitialData()
        getCurrentUserProfile()
        
        tblSideMenu.reloadData()
    }
    
    //MARK: - user actions
    @IBAction func btnUserProfileClicks(_ sender: Any) {
        
        if AppSelectedUserType == .Student {
            
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "StudentProfileVC") as! StudentProfileVC
            self.navigationController?.pushViewController(vc, animated: false)

        }else {
            self.pushTo("ProfileVC")
        }

    }
    
    @IBAction func btnCloseMenuClick(_ sender: Any) {
        self.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: Notification.Name("SideMenuDidClosed"), object: nil)
        }
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnEditProfileClick(_ sender: Any) {
        
        if AppSelectedUserType == .Student {
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "EditStudentsVC") as! EditStudentsVC
            self.navigationController?.pushViewController(vc, animated: false)

        }else {
            self.pushTo("EditProfileVC")
        }
    }
        
    @IBAction func switchUserTypeChanges(_ sender: UISwitch) {

        sidemenuViewModel.newRole = (sender.isOn ? .Student : .Instructor)
        
        sidemenuViewModel.WSSwitchUserRole { response in
            
            self.CheckUserDetailsFilled()
            //print
            self.setInitialData()

        } failure: { err in
            //error
            sender.isOn = !sender.isOn
        }

    }
}

//MARK: - GENERAL METHODS
extension  SideMenuVC {
    
    func setInitialData() {
        
        // for development time
        imgProfilePicture.kf.indicatorType = .activity
        imgProfilePicture.kf.setImage(with: URL(string: AviationUser.shared.profileImage), placeholder: UIImage(named: ""), options: nil, completionHandler: nil)
        
        lblUserName.text = AviationUser.shared.name
        
        switchBecomeStudent.isOn = (AppSelectedUserType == .Student)
        
        if AppSelectedUserType == .Student {
            arrMenus = [
                Menu(name: "Home"),
                Menu(name: "Find instructors"),
                Menu(name: "Events"),
                Menu(name: "Change Password"),
                Menu(name: "Log Out")
            ]
        }else {
            arrMenus = [
                Menu(name: "Home"),
                Menu(name: "Students"),
                Menu(name: "Events"),
                Menu(name: "Change Password"),
                Menu(name: "Log Out")
            ]
        }
        tblSideMenu.reloadData()
    }
    
    private func CheckUserDetailsFilled() {
        
        if AppSelectedUserType == .Student {
            
            if (AviationUser.shared.certificateId == nil) {
                let vc = storyBoards.Student.instantiateViewController(withIdentifier: "EditStudentsVC") as! EditStudentsVC
                vc.isFromFillRemainingData = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        }else {
            if (AviationUser.shared.experienceInYear == nil || AviationUser.shared.approxHours == nil || AviationUser.shared.airportId == nil) || (AviationUser.shared.experienceInYear == 0 || AviationUser.shared.approxHours.isEmpty || AviationUser.shared.airportId == 0) {

                let vc = storyBoards.Home.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                vc.isFromFillRemainingData = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
    }
}

//MARK: - tableview delegate datasource methods
extension SideMenuVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSideMenu.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        
        cell.lblMenuTitle.text = arrMenus[indexPath.row].name
        
        if arrMenus[indexPath.row].name == "Log Out" {
            cell.lblMenuTitle.textColor = .appColor
        }else {
            cell.lblMenuTitle.textColor = .black
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        //dismiss(animated: true) {
            switch self.arrMenus[indexPath.row].name {
            
            case "Home" :
                let vc = storyBoards.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(vc, animated: false)
                break
                
            case "Students" :
                let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AllStudentsVC") as! AllStudentsVC
                self.navigationController?.pushViewController(vc, animated: false)
                break
                
            case "Find instructors" :
                let vc = storyBoards.Student.instantiateViewController(withIdentifier: "InstructorListsVC") as! InstructorListsVC
                self.navigationController?.pushViewController(vc, animated: false)
                break

            case "Events" :
                let vc = storyBoards.Event.instantiateViewController(withIdentifier: "EventsListsVC") as! EventsListsVC
                self.navigationController?.pushViewController(vc, animated: false)
                break

            case "Change Password" :
                let vc = storyBoards.Home.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vc, animated: false)
                break
                
            case "Log Out":
                doLogOut()
                
            default :
                let vc = storyBoards.Home.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
        //}
    }
}

//MARK: -  LOGUT
extension SideMenuVC {
    
    func doLogOut() {
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: AlertMessage.logoutMessage, buttons: ["Cancel","Logout"]) { (i) in
            
            if(i == 1){
                self.sidemenuViewModel.WSLogout { response in
                    //
                    appDelegate.setLoginScreen()
                } failure: { errorResponse in
                    //error
                }
            }
            
        }
    }
    
    private func getCurrentUserProfile() {
        
        let profileVM = ProfileViewModel()
        profileVM.userID = AviationUser.shared.id.integerValue
        
        profileVM.WSGetMyProfile { response in
            
            self.setInitialData()
            
        } failure: { errorResponse in
            //
        }
    }

    
}


//MARK: - for open sidemenu from any viewcontroller
extension UIViewController {
    
    func openSideMenu() {
        let menu = storyBoards.Home.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController

        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = UIScreen.main.bounds.width
        menu.dismissDuration = 0
        menu.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        present(menu, animated: true, completion: nil)
    }

}
