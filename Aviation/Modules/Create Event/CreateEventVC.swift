//
//  CreateEventVC.swift
//  Aviation
//
//  Created by Zestbrains on 23/11/21.
//

import UIKit
import SKCountryPicker
import IQKeyboardManagerSwift

class CreateEventVC  : UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var scrollMain: UIScrollView!

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var txtSelectStudent: AppCommonPickerTextField!
    
    @IBOutlet weak var txtDate: AppCommonPickerTextField!
    
    @IBOutlet weak var txtAgenda: AppCommonTextField!
    
    @IBOutlet weak var txtLocations: AppCommonTextField!
    
    @IBOutlet weak var txtCountry: AppCommonTextField!
    
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: AppCommonTextField!
    
    @IBOutlet weak var txtInvite: AppCommonTextField!
    
    @IBOutlet weak var btnAddInvitation: EMButton! {
        didSet {
            btnAddInvitation.btnType = .Submit
        }
    }
    
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var tblInvitatationUsers: UITableView!
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var constraintTblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDeleteBtn: UIView!
    
    @IBOutlet weak var aviationList: AviationLVW! {
        didSet {
            self.aviationList.delegate = self
            aviationVM.getNearByAirports(self) { arr in
                self.aviationList.arrAviations = arr
            }
        }
    }

    //MARK: - VARIABLES
    private let myStudentsVM = StudentsViewModel()
    private let createEventVM = CreateEventViewModel()
    private let debounce = Debouncer()
    private let aviationVM = AviationsViewModel.shared
    
    var eventModelObj : ModelEventsMain?
    private let eventsVM = EventListViewModel()

    var arrSelectedStudentIds : [Int] = []
    var arrEmails : [String] = [] {
        didSet {
            tblInvitatationUsers.reloadData()
        }
    }
    
    private let pickerCertificates : UIPickerView = UIPickerView()
    private var studentPicker : YBTextPicker!
        
    var isFromEdit : Bool = false
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblInvitatationUsers.registerCell(type: EventInvitationTVC.self)
        tblInvitatationUsers.setDefaultProperties(vc: self)
        
        if isFromEdit {
            self.viewDeleteBtn.isHidden = false
            
            self.getEventDetails()
            
        }else {
            self.viewDeleteBtn.isHidden = true
        }
        
        setPickers()
        
        getMyStudents()
        
        //for edit event
        self.bindEventData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblInvitatationUsers.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tblInvitatationUsers.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblInvitatationUsers && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    
                    constraintTblHeight.constant = newSize.height
                }
            }
        }
    }
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    @IBAction func btnSaveClicks(_ sender: Any) {
        
        self.addDataInModel()
        
        createEditEvent()
    }
    
    @IBAction func btnCountryPickerClicks(_ sender: Any) {

        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country) in
            
            self.lblCountryCode.text = country.dialingCode
        }
        countryController.detailColor = UIColor.black
    }
    
    @IBAction func btnSelectStudentClicks(_ sender: Any) {
        setupStudentData()
    }
    
    @IBAction func btnAddInvitationClicks(_ sender: Any) {
        
        if validateData() {
            
            self.arrEmails.append((txtInvite.text ?? ""))
            txtInvite.text = ""
            
        }
        
    }
    
    @IBAction func btnDeleteEventClicks(_ sender: Any) {
        showAlertWithTitleFromVC(vc: self, title: "Confirmation", andMessage: "Are you sure you want to delete this event ?", buttons: ["Yes" , "No"]) { tag in
            
            if tag == 0 {
                self.deleteEvent()
            }else {
                
            }
        }

    }
}

extension CreateEventVC {
    
    // TODO: Validation
    func validateData() -> Bool {
        
        guard (txtInvite.text?.removeWhiteSpace().count)! > 0  else
        {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
            return false
        }
        
        //        guard (txtInvite.text)!.removeWhiteSpace().isEmail() else
        //        {
        //            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
        //            return false
        //        }
        
        return true
    }
}

//MARK: - GENERAL METHODS
extension  CreateEventVC {
    
    func setPickers() {

        let datePicker = UIDatePicker()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        txtDate.inputView = datePicker
    }

    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        txtDate.text = dateFormatter.string(from: sender.date)
    }
}

//MARK: - UITextFieldDelegate METHODS
extension  CreateEventVC : UITextFieldDelegate , SelectAviationDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDate {
            if textField.text == "" {
                txtDate.text = getStrDateFromDate(date: Date(), formate: "dd MMM yyyy hh:mm a")
            }
        }else if textField == txtLocations {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtLocations {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtLocations {
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString =
            currentString.replacingCharacters(in: range, with: string)
            
            let filterArr =  aviationVM.arrAviations.filter({($0.name.localizedCaseInsensitiveContains(newString)) || ($0.localCode.localizedCaseInsensitiveContains(newString))})
            aviationList.arrAviations = filterArr
            
            var rect = textField.superview?.convert(textField.frame, to: scrollMain) ?? .zero
            rect.size.height = textField.frame.size.height + ((filterArr.count == 0) ? 0 : aviationList.frame.size.height) + 35
            self.scrollMain.scrollRectToVisible(rect, animated: true)

        }

        return true
    }

    func didSelectAviation(avition: ModelProfileAirport) {
        self.view.endEditing(true)
        
        aviationList.isHidden = true
        
        txtLocations.text = "\(avition.name ?? "") (\(avition.localCode ?? ""))"
        createEventVM.locationID = avition.id ?? 0
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CreateEventVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrEmails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventInvitationTVC") as? EventInvitationTVC {
            
            cell.lblEmail.text = arrEmails[indexPath.row]
            
            cell.btnCloser = { _ in
                
                self.arrEmails.remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - Setup Student Selection view
extension  CreateEventVC {
    
    func setupStudentData() {
        let regularFont = Font(.installed(.Regular), size: .custom(16.0)).instance
        let boldFont = Font(.installed(.Bold), size: .custom(16.0)).instance
        let blueColor = UIColor.appColor
        
        let blueAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Students",
            titleFont           : boldFont,
            titleTextColor      : .black,
            titleBackground     : .clear,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Students",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : blueColor,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named: "blue_ic_checked"),
            itemUncheckedImage  : UIImage(),
            itemColor           : .black,
            itemFont            : regularFont
        )
        
        let arrStudents = self.myStudentsVM.arrStudents.map({($0.name ?? "")})
        self.studentPicker = YBTextPicker.init(with: arrStudents, appearance: blueAppearance, onCompletion: { (selectedIndexes, selectedValues) in
            if selectedValues.count > 0{
                
                var values = [String]()
                self.arrSelectedStudentIds.removeAll()
                
                for index in selectedIndexes{
                    values.append(arrStudents[index])
                    self.arrSelectedStudentIds.append(self.myStudentsVM.arrStudents[index].id)
                }
                
                self.txtSelectStudent.text = values.joined(separator: ", ")
                
            }else{
                self.arrSelectedStudentIds.removeAll()
                self.txtSelectStudent.text = ""
            }
        }, onCancel: {
            print("Cancelled")
        }
        )
        
        if let title = self.txtSelectStudent.text {
            //arrSelectedStudentIds =
            studentPicker.preSelectedValues = title.components(separatedBy: ",")
        }
        studentPicker.allowMultipleSelection = true
        
        studentPicker.show(withAnimation: .Fade)
    }
}



//MARK: - GENERAL METHODS
extension  CreateEventVC {
    
    private func bindEventData() {
        
        viewScreenData.isHidden = false
        
        if isFromEdit {

            lblHeaderTitle.text = "Edit Event"

            if let obj = eventModelObj {
             
                let arr = obj.joinedStudents ?? []
                createEventVM.eventID = obj.id
                
                self.arrSelectedStudentIds = arr.map({$0.studentId.id ?? 0})
                
                let str = arr.map({($0.studentId.name ?? "")})
                txtSelectStudent.text = str.joined(separator: ",")
                
                txtDate.text = getStrDateFromDate(date: (obj.datetime ?? ""), fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy hh:mm a")
                
                txtAgenda.text = obj.agenda
                txtNote.text = obj.descriptionField

                txtLocations.text = obj.location.name
                createEventVM.locationID = obj.location.id

                arrEmails = obj.event_emails.map({$0.email ?? ""})
                createEventVM.arrEmails = arrEmails
                
                lblCountryCode.text = obj.countryCode
                txtPhoneNumber.text = obj.mobile
            }
            
        }else {
            lblHeaderTitle.text = "Create Event"
        }
    }
    
    private func addDataInModel() {
        createEventVM.vc = self
        
        createEventVM.arrStudentsIds = arrSelectedStudentIds
        createEventVM.strDateTime = txtDate.text ?? ""
        
        createEventVM.strAgenda = txtAgenda.text ?? ""
        createEventVM.strDescription = txtNote.text ?? ""
        createEventVM.countryCode = lblCountryCode.text ?? ""
        createEventVM.mobile = txtPhoneNumber.text ?? ""
        createEventVM.arrEmails = arrEmails
    }
}



//MARK: - APIs
extension  CreateEventVC {
    
    private func getEventDetails() {
        
        viewScreenData.isHidden = true
        
        eventsVM.getEventDetails(id: (self.eventModelObj?.id ?? 0).description, isShowLoader: true) { success in
            
            self.eventModelObj = ModelEventsMain(fromJson: success["data"])
            self.bindEventData()
            
        } failure: { errorResponse in
            //failure
        }
    }

    private func getMyStudents() {
        myStudentsVM.offset = 0
        myStudentsVM.limit = 100000
        
        myStudentsVM.getMyStudents(strSearch: "") { response in
            
        } failure: { errorResponse in
            //failur
        }
    }
    
    private func createEditEvent() {
        
        createEventVM.AddEditEventAPI { success in
            self.popTo()
        } failure: { errorResponse in
            //fails
        }
        
    }
    
    private func deleteEvent() {
                
        createEventVM.deleteEventAPI { success in
            self.popTo()
        } failure: { errorResponse in
            //fails
        }
        
    }

}
