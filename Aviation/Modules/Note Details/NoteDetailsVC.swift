//
//  NoteDetailsVC.swift
//  Aviation
//
//  Created by Zestbrains on 22/11/21.
//

import UIKit

class NoteDetailsVC : UIViewController {
    
    //MARK: - OUTLETS
    

    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
            
    @IBOutlet weak var collectionTags: UICollectionView!
    
    @IBOutlet weak var lblNotes: UILabel!
    
    @IBOutlet weak var lblPrivateNotes: UILabel!
        
    @IBOutlet weak var viewCreatedBy: UIView!
    @IBOutlet weak var lblCreatedBy: UILabel!
    
    @IBOutlet weak var viewPersonalNotes: UIView!
    
    @IBOutlet weak var btnExport: EMButton! {
        didSet {
            btnExport.btnType = .Submit
        }
    }
    
    @IBOutlet weak var btnEditNotes: UIButton!
    
    //MARK: - VARIABLES
    private let notesVM = StudentNotesViewModel()
    
    var noteID : String = ""

    //TAGS
    var arrTags : [String] = []
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionTags.registerCell(type: TagsCVC.self)

        collectionTags.setDefaultProperties(vc: self)
        
        setInitailData()
        getNoteDetails()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.collectionTags.reloadData()
        }
        
        btnEditNotes.isHidden = (AppSelectedUserType == .Student)
    }

    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
            
    @IBAction func btnEditClicks(_ sender: Any) {
        let vc = storyBoards.Student.instantiateViewController(withIdentifier: "AddNotesVC") as! AddNotesVC
        vc.isFromEdit = true
        vc.notesModel = notesVM.notesModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnExportClicks(_ sender: Any) {
        if let strURL = notesVM.notesModel.pdfUrl {
            downloadDocument(strFile: strURL, strFileName: "Aviation_Note_\(Date().timeIntervalSince1970).pdf")
        }
    }
    
}

//MARK: - GENERAL METHODS
extension  NoteDetailsVC {
    
    func setInitailData() {
        
        if AppSelectedUserType == .Student {
            
            viewCreatedBy.isHidden = false
            viewPersonalNotes.isHidden = true
            
        }else {
            
            viewCreatedBy.isHidden = true
            viewPersonalNotes.isHidden = false
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension  NoteDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVC", for: indexPath) as?  TagsCVC {
            
            cell.lblTags.text = arrTags[indexPath.row]
            cell.isShowRemoveBtn = false
            cell.deleteCloser = { sender in
                self.arrTags.remove(at: indexPath.row)
                collectionView.reloadData()
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: collectionView.frame.size.height))
        
        lbl.numberOfLines = 1
        lbl.font = Font(.installed(.Regular), size: .standard(.h513)).instance
        
        lbl.text = arrTags[indexPath.row]
        lbl.sizeToFit()
        lbl.frame.size.height = collectionView.frame.size.height
        
        let spacing : CGFloat = 20
        let deleteBtnSize : CGFloat = 0 //collectionView.frame.size.height - if there is remove button show
        
        return CGSize(width: lbl.frame.size.width + (spacing * 2) + deleteBtnSize , height: collectionView.frame.size.height)
    }
}


//MARK: - API Call
extension  NoteDetailsVC {
    
    private func getNoteDetails() {
        
        viewScreenData.isHidden = true
        
        notesVM.getNoteDetails(id: self.noteID, isShowLoader: true) { success in
            
            self.bindData()
            
        } failure: { errorResponse in
            //failure
        }
    }
    
}

//MARK: - GENERAL METHODS
extension  NoteDetailsVC {
    
    private func bindData() {
        
        viewScreenData.isHidden = false
        
        if let obj = notesVM.notesModel {
        
            lblDate.text = getStrDateFromDate(date: (obj.datetime ?? ""), fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy, hh:mm a")
        
            lblTime.text = obj.totalHours
            
            arrTags.removeAll()
            arrTags = obj.tags.components(separatedBy: ",")
            collectionTags.reloadData()
            
            lblNotes.text = obj.note
            lblPrivateNotes.text = obj.privateNote
            
            lblCreatedBy.text = obj.instructorId?.name ?? ""
        }
    }
    
}

