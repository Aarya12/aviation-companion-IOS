//
//  AllNotesVC.swift
//  Aviation
//
//  Created by Zestbrains on 24/12/21.
//

import UIKit

class AllNotesVC: UIViewController {
    
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
    
    //MARK: - VARIABLES
    private let notesVM = StudentNotesViewModel()
    private var isDataLoading : Bool = false

    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblStudents.registerCell(type: StudentNotesTVC.self)
        tblStudents.registerCell(type: LoadingTVC.self)
        tblStudents.setDefaultProperties(vc: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewSearch.Round = true
            self.tblStudents.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //adding notitifcation observer
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: Notification.Name("SideMenuDidClosed"), object: nil)
         
        setupInitialData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //To Remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didReceiveNotification(_ notification : Notification) {
        
        self.tblStudents.reloadData()
        
    }

    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        print("btnBackClicks")

        self.popTo()
    }
        
    @IBAction func btnSearchClicks(_ sender: Any) {
        
    }
    
    @IBAction func btnStudentImgClicks(_ sender: Any) {
    
        if AppSelectedUserType == .Student {
            let vc = storyBoards.Home.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)

        }else {
            self.pushTo("StudentProfileVC")
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AllNotesVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if notesVM.hasMoreData {
            return 2
        }else {
            return 1
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            if (self.notesVM.arrNotes.count == 0) && (isDataLoading == false){
                tableView.setEmptyMessage("No notes found!")
            }else {
                tableView.setEmptyMessage("")
            }

            return notesVM.arrNotes.count
            
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "StudentNotesTVC") as? StudentNotesTVC{
                
                if notesVM.arrNotes.count > indexPath.row {
                    let obj = notesVM.arrNotes[indexPath.row]
                    cell.bindData(obj: obj)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if AppSelectedUserType == .Student {
            return nil
        }
        
        if indexPath.section == 0 {
            
            let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                
                let vc = storyBoards.Student.instantiateViewController(withIdentifier: "DeleteNotePopupVC") as! DeleteNotePopupVC
                
                vc.noteID = (self.notesVM.arrNotes[indexPath.row].id ?? 0).description
                vc.noteDeleteCloser = {
                    self.notesVM.arrNotes.remove(at: indexPath.row)
                    tableView.reloadData()
                }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
                
                completionHandler(true)
                
            })
            
            if #available(iOS 13.0, *) {
                action.image = UIGraphicsImageRenderer(size: CGSize(width: 70, height: 70)).image { _ in
                    UIImage(named: "ic_delete_note")?.draw(in: CGRect(x: 0, y: 0, width: 70, height: 70))
                }
                action.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
                let confrigation = UISwipeActionsConfiguration(actions: [action])
                return confrigation
            } else {
                // Fallback on earlier versions
                //let cgImageX =  UIImage(named: "ic_delete_note")?.cgImage
                action.image =  UIImage(named: "ic_delete_note") //OriginalImageRender(cgImage: cgImageX!)
                action.backgroundColor = .white
                let confrigation = UISwipeActionsConfiguration(actions: [action])
                
                return confrigation
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let vc = storyBoards.Student.instantiateViewController(withIdentifier: "NoteDetailsVC") as! NoteDetailsVC
            vc.noteID = (notesVM.arrNotes[indexPath.row].id ?? 0).description
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

//MARK: - API Calls
extension  AllNotesVC {
    
    private func getNotes(isShowLoader : Bool = true) {
        
        notesVM.strSearch = txtSearch.text!
        
        notesVM.getAllNotes(isShowLoader: isShowLoader) { success in
            
            self.isDataLoading = false
            self.tblStudents.reloadData()
            
        } failure: { errorResponse in
            //failure
            self.isDataLoading = false
            self.tblStudents.reloadData()
        }
    }
    
}

//MARK: - Pagination
extension AllNotesVC {
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblStudents {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 350 {
                
                if !isDataLoading {
                    isDataLoading = true

                    if notesVM.hasMoreData {
                        self.getNotes(isShowLoader: false)
                    }
                }
            }
        }
    }

}

//MARK: - TEXTFIELD DELEGATEs
extension AllNotesVC : UITextFieldDelegate {
    
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
extension  AllNotesVC {
    
    func setupInitialData() {
        self.view.endEditing(true)
        
        isDataLoading = true
        notesVM.offset = 0
     
        txtSearch.delegate = self
        txtSearch.clearButtonMode = .always
        
        getNotes()
    }
}
