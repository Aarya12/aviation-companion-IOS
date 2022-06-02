//
//  EventsListsVC.swift
//  Aviation
//
//  Created by Zestbrains on 22/11/21.
//

import UIKit

class EventsListsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var segmentEventType: UISegmentedControl!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var btnAdd: UIButton!

    //MARK: - VARIABLES
    private let eventsVM = EventListViewModel()
    private var isDataLoading : Bool = false

    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tblEvents.registerCell(type: EventsTVC.self)
        tblEvents.registerCell(type: LoadingTVC.self)
        tblEvents.setDefaultProperties(vc: self)
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
         
        btnAdd.isHidden = (AppSelectedUserType == .Student)
        
        setupInitialData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //To Remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveNotification(_ notification : Notification) {
        
        btnAdd.isHidden = (AppSelectedUserType == .Student)
        self.tblEvents.reloadData()
        
    }

    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    @IBAction func segmentChanges(_ sender: Any) {
        self.setupInitialData()
    }
    
    @IBAction func btnAddClicks(_ sender: Any) {
        
        if AppSelectedUserType == .Student {
            //not have add functionality
        }else {
            
            let vc = storyBoards.Event.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSearchClicks(_ sender: Any) {
        self.view.endEditing(true)
        
    }
    
    //MARK: - OTHER FUNCTIONS
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension EventsListsVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if eventsVM.hasMoreData {
            return 2
        }else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if (self.eventsVM.arrEvents.count == 0) && (isDataLoading == false){
                tableView.setEmptyMessage("No events found!")
            }else {
                tableView.setEmptyMessage("")
            }

            return eventsVM.arrEvents.count
            
        }else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTVC") as? EventsTVC{
                
                if eventsVM.arrEvents.count > indexPath.row {
                    let obj = eventsVM.arrEvents[indexPath.row]
                    
                    cell.bindData(obj: obj)
                    cell.btnCloser = { sender in
                        let vc = storyBoards.Event.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
                        vc.isFromEdit = true
                        vc.eventModelObj = obj
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                }
                return cell
            }
            
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTVC") as? LoadingTVC{
                cell.startLoading()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if eventsVM.arrEvents.count > indexPath.row {
            let obj = eventsVM.arrEvents[indexPath.row]

            if AppSelectedUserType == .Student {

                let vc = storyBoards.Event.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
                vc.eventID = (obj.id ?? 0).description
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                
                let vc = storyBoards.Event.instantiateViewController(withIdentifier: "CreateEventVC") as! CreateEventVC
                vc.isFromEdit = true
                vc.eventModelObj = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
    }
}

//MARK: - API Calls
extension  EventsListsVC {
    
    private func getEvents(isShowLoader : Bool = true) {
        
        eventsVM.strSearch = txtSearch.text!
        eventsVM.getMyEvents(isShowLoader: isShowLoader) { success in
            
            self.isDataLoading = false
            self.tblEvents.reloadData()
            
        } failure: { errorResponse in
            //failure
            self.isDataLoading = false
            self.tblEvents.reloadData()
        }
    }
    
}

//MARK: - Pagination
extension EventsListsVC {
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblEvents {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 350 {
                
                if !isDataLoading {
                    isDataLoading = true

                    if eventsVM.hasMoreData {
                        self.getEvents(isShowLoader: false)
                    }
                }
            }
        }
    }

}

//MARK: - TEXTFIELD DELEGATEs
extension EventsListsVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if !textField.text!.isEmpty {
            setupInitialData()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        textField.text = ""
        setupInitialData()

        return false
    }
}


//MARK: - GENERAL METHODS
extension  EventsListsVC {
    
    func setupInitialData() {
        self.view.endEditing(true)
        
        isDataLoading = true
        eventsVM.offset = 0
     
        eventsVM.type = (segmentEventType.selectedSegmentIndex == 0) ? "upcoming" : "past"
        
        txtSearch.delegate = self
        txtSearch.clearButtonMode = .always
        getEvents()
    }
}
