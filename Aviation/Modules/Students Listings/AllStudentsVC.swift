//
//  AllStudentsVC.swift
//  Aviation
//
//  Created by Zestbrains on 17/11/21.
//

import UIKit

class AllStudentsVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var tblStudents: UITableView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!

    //MARK: - VARIABLES
    var isFromScreen : isFrom = .HomeViewAll
    private var studentsVM = StudentsViewModel()
    private var isDataLoading : Bool = false
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblStudents.registerCell(type: LoadingTVC.self)

        tblStudents.registerCell(type: AllStudentsTVC.self)
        tblStudents.setDefaultProperties(vc: self)
        
        setupInitialData()
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //To Remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveNotification(_ notification : Notification) {
        
        btnAdd.isHidden = (AppSelectedUserType == .Student)
        self.tblStudents.reloadData()
        
    }

    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    @IBAction func btnAddClicks(_ sender: Any) {
        
        let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AddStudentPopupVC") as! AddStudentPopupVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSearchClicks(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}

//MARK: - GENERAL METHODS
extension  AllStudentsVC {
    
    func setupInitialData() {
        self.view.endEditing(true)
        
        if AppSelectedUserType == .Student {
            lblHeaderTitle.text = "Instructor"
            txtSearch.placeholder = "Search instructor by name , email"
            
            GetAllInstructor()
        }else {

            isDataLoading = true
            studentsVM.offset = 0
            if self.isFromScreen == .HomeSearch {
                lblHeaderTitle.text = "All Students"
                txtSearch.placeholder = "Search Aviation Companion Students"
                GetAllStudents()
            }else {
                txtSearch.placeholder = "Search Your Students"

                lblHeaderTitle.text = "My Students"
                GetMyStudents()
            }
            txtSearch.placeholder = "Search your Students"
        }
        
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension AllStudentsVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if studentsVM.hasMoreData {
            return 2
        }else {
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if AppSelectedUserType == .Instructor {
                
                if (self.studentsVM.arrStudents.count == 0) && (isDataLoading == false){
                    tableView.setEmptyMessage("No students found!")
                }else {
                    tableView.setEmptyMessage("")
                }

                return studentsVM.arrStudents.count
                
            }else {
                if (self.studentsVM.arrStudents.count == 0) && (isDataLoading == false){
                    tableView.setEmptyMessage("No instructors found!")
                }else {
                    tableView.setEmptyMessage("")
                }

                return studentsVM.arrStudents.count
            }
            
        }else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AllStudentsTVC") as? AllStudentsTVC{
                
                cell.btnAdd.isHidden = true
                cell.btnViewNotes.isHidden = false
                cell.btnViewProfile.isHidden = false
                cell.lblStudentNotes.isHidden = false

                if AppSelectedUserType == .Student {
                    //setup instructor
                    if studentsVM.arrStudents.count > indexPath.row
                    {

                    cell.bindData(obj: studentsVM.arrStudents[indexPath.row], isForAllStudnets: false)
                    }
                }else {
                    
                    if studentsVM.arrStudents.count > indexPath.row
                    {
                        if self.isFromScreen == .HomeSearch {
                            //All Students
                            cell.bindData(obj: studentsVM.arrStudents[indexPath.row])
                        }else {
                            //My Students setups
                            cell.bindData(obj: studentsVM.arrStudents[indexPath.row], isForAllStudnets: false)
                        }
                    }
                }
                
                cell.btnCloser = { sender in
                    
                    switch sender {
                    case cell.btnAdd :
                        if !sender.isSelected {
                            sender.isSelected = true
                            self.studentsVM.arrStudents[indexPath.row].isAlreadyStudent = "1"
                            self.AddStudent(studentId: self.studentsVM.arrStudents[indexPath.row].id ?? 0 )
                            tableView.reloadData()
                        }
                        
                        break
                        
                    case cell.btnViewNotes :
                        let vc = storyBoards.Student.instantiateViewController(withIdentifier: "StudentNotesVC") as! StudentNotesVC
                        vc.profileModel = self.studentsVM.arrStudents[indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                        break
                        
                    case cell.btnViewProfile , cell.btnStudentProfile:
                        
                        if AppSelectedUserType == .Student {
                            let vc = storyBoards.Home.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "StudentProfileVC") as! StudentProfileVC
                            vc.userID =  self.studentsVM.arrStudents[indexPath.row].id.description
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        break
                    default:
                        break
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
     
        if isFromScreen != .HomeSearch {
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "StudentNotesVC") as! StudentNotesVC
            vc.profileModel = studentsVM.arrStudents[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - API CALLS AND BIND WITH VM
extension  AllStudentsVC {
    
    private func GetAllStudents(isShowLoader : Bool = true) {
        
        studentsVM.getAllStudents(strSearch: (txtSearch.text ?? ""), isShowLoader: isShowLoader) { response in
            
            self.isDataLoading = false
            self.tblStudents.reloadData()
            
        } failure: { error in
            //failur
            self.isDataLoading = false
            self.tblStudents.reloadData()
        }
    }

    private func GetMyStudents(isShowLoader : Bool = true) {
        
        studentsVM.getMyStudents(strSearch: (txtSearch.text ?? ""), isShowLoader: isShowLoader) { response in
            
            self.isDataLoading = false
            self.tblStudents.reloadData()
            
        } failure: { error in
            //failur
            self.isDataLoading = false
            self.tblStudents.reloadData()
        }
    }

    private func AddStudent(studentId : Int){
        
        studentsVM.addStudent(id: studentId) { response in
            //success
        } failure: { error in
            //fail
        }
    }
    
    private func GetAllInstructor(isShowLoader : Bool = true) {
        
        studentsVM.getMyInstructors(strSearch: (txtSearch.text ?? ""), isShowLoader: isShowLoader) { response in
            
            self.isDataLoading = false
            self.tblStudents.reloadData()
            
        } failure: { error in
            //failur
            self.isDataLoading = false
            self.tblStudents.reloadData()
        }
    }

}

//MARK: - Pagination
extension AllStudentsVC {
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblStudents {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 350 {
                
                if !isDataLoading {
                    isDataLoading = true

                    if studentsVM.hasMoreData {
                        
                        if AppSelectedUserType == .Student {
                            
                            GetAllInstructor(isShowLoader: false)
                            
                        }else {
                            if self.isFromScreen == .HomeSearch {

                                self.GetAllStudents(isShowLoader: false)
                            }else {
                                GetMyStudents(isShowLoader: false)
                            }
                        }
                    }
                }
            }
        }
    }

}

//MARK: - TEXTFIELD DELEGATEs
extension AllStudentsVC : UITextFieldDelegate {
    
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
