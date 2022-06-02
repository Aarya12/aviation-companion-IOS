//
//  DeleteNotePopupVC.swift
//  Aviation
//
//  Created by Zestbrains on 22/11/21.
//

import UIKit

class DeleteNotePopupVC : UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var btnNo: EMButton! {
        didSet {
            btnNo.btnType = .Submit
        }
    }
    
    @IBOutlet weak var btnYes: UIButton!
    
    
    //MARK: - VARIABLES
    private let notesVM = StudentNotesViewModel()
    var noteID : String = ""
    var noteDeleteCloser : voidCloser?
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnOverlayClicks(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func btnNoClicks(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnYesClicks(_ sender: Any) {
        deleteNote()
    }
    
}

extension  DeleteNotePopupVC {
    
    private func deleteNote() {
        
        notesVM.deleteNote(id: self.noteID, isShowLoader: true) { success in
            
            self.dismiss(animated: true) {
                //dismiss completions
                self.noteDeleteCloser?()
            }
            
        } failure: { errorResponse in
            //failure
        }
    }
    
}
