//
//  HomeVC.swift
//  Aviation
//
//  Created by Zestbrains on 12/11/21.
//

import UIKit
import SwiftyJSON

class HomeVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var lblSearchTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var viewSearch: UIView! {
        didSet {
            viewSearch.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor, shadowOffset: CGSize(width: 0, height: 8), shadowOpacity: 1, shadowRadius: 8)
        }
    }
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var tblScreenData: UITableView!
    
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
    //MARK: - VARIABLES
    private let homeVM = HomeViewModel()
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblScreenData.register(UINib(nibName: "HomeHeaderTVC", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderTVC")
        
        tblScreenData.registerCell(type: HomeTVC.self)
        
        tblScreenData.setDefaultProperties(vc: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewSearch.Round = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //adding notitifcation observer
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: Notification.Name("SideMenuDidClosed"), object: nil)
        
        tblScreenData.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.tblScreenData.reloadData()

        btnAdd.isHidden = (AppSelectedUserType == .Student)
        
        SetInitialData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tblScreenData.removeObserver(self, forKeyPath: "contentSize")

        //To Remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveNotification(_ notification : Notification) {
        
        print("didReceiveNotification")
        
        btnAdd.isHidden = (AppSelectedUserType == .Student)
        self.tblScreenData.reloadData()
        
        SetInitialData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblScreenData && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    //TODO: - for scroll full screen
                    constraintTableHeight.constant = newSize.height
                }
            }
        }
    }

    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnSideMenuClicks(_ sender: Any) {
        self.openSideMenu()
    }
    
    @IBAction func btnAddClicks(_ sender: Any) {
        //AddPopupVC
        
        let vc = storyBoards.Home.instantiateViewController(withIdentifier: "AddPopupVC") as! AddPopupVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func btnSearchClicks(_ sender: Any) {
        
        if AppSelectedUserType == .Instructor {
            //SEE ALL STUDENT SELECT
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AllStudentsVC") as! AllStudentsVC
            vc.isFromScreen = .HomeSearch
            self.navigationController?.pushViewController(vc, animated: true)

        }else {
            //
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AllNotesVC") as! AllNotesVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerVw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderTVC")  as! HomeHeaderTVC
        
        headerVw.section = section
        headerVw.delegate = self
        
        if section == 0{
            if AppSelectedUserType == .Student {
                headerVw.lblTitle.text = "Instructors"
            }else {
                headerVw.lblTitle.text = "Students"
            }
        }else {
            headerVw.lblTitle.text = "Events"
        }
        
        return headerVw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC") as? HomeTVC{
            
            cell.delegate = self
            cell.section = indexPath.section
            if indexPath.section == 0 {
                let height : CGFloat = (AppSelectedUserType == .Instructor) ? 217.0 : 182.0

                cell.gridCellSize = CGSize(width: 165.0, height: height)
                cell.ConstraintCollectionHeight.constant = height

            }else {
                
                let height : CGFloat = (AppSelectedUserType == .Student) ? 200 : 256
                cell.gridCellSize = CGSize(width: 245, height: height)
                cell.ConstraintCollectionHeight.constant = height
            }

            cell.homeModel = homeVM.homeModel
            cell.collectionDatas.reloadData()
            cell.layoutIfNeeded()
            
            return cell
        }
        return UITableViewCell()
    }
    
}

//MARK: -
extension HomeVC : HomeCellsDelegate {
    func didSelectSeeAll(section: Int) {

        switch section {
        case 0:
            //SEE ALL STUDENT SELECT
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AllStudentsVC") as! AllStudentsVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 1:
            //SEE ALL EVENT SELECT
            let vc = storyBoards.Event.instantiateViewController(withIdentifier: "EventsListsVC") as! EventsListsVC
            self.navigationController?.pushViewController(vc, animated: true)

            break
            
        default:
            print("section")
        }
        
    }
    
    func didSelectCollectionCell(section: Int, selected indexPath: IndexPath) {
        
        guard let homeObj = homeVM.homeModel else { return }
        
        switch section {
        case 0 :
            //STUDENT SELECT
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "StudentNotesVC") as! StudentNotesVC
            vc.profileModel = ModelStudents(fromJson: JSON(homeObj.users[indexPath.row].user.toDictionary()))
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            
            //EVENTS
            if AppSelectedUserType == .Student {

                let vc = storyBoards.Event.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
                vc.eventID = (homeObj.events[indexPath.row].id ?? 0).description
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                
                let vc = storyBoards.Event.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
                vc.isFromEdit = true
                vc.eventModelObj = ModelEventsMain(fromJson: JSON(homeObj.events[indexPath.row].toDictionary()))
                self.navigationController?.pushViewController(vc, animated: true)
            }

            break
            
        default:
            print("section")
        }

    }
}


//MARK: - GENERAL METHODS
extension  HomeVC {
    
    func SetInitialData() {
        if AppSelectedUserType == .Student {
            lblSearchTitle.text = "Search Notes"
        }else{
            lblSearchTitle.text = "Search Students"
        }
        
        lblUserName.text = AviationUser.shared.name
        getHomeDetails()
    }
}

//MARK: - APIs Call
extension HomeVC {
    
    func getHomeDetails() {
        
        homeVM.getHomeDetails { response in
            
            self.tblScreenData.reloadData()
            
        } failure: { errorResponse in
            //Failuer
        }
        
    }
    
}
