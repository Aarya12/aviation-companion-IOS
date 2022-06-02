//
//  EventDetailsVC.swift
//  Aviation
//
//  Created by Zestbrains on 15/12/21.
//

import UIKit

class EventDetailsVC  : UIViewController {
    
    //MARK: - OUTLETS
    

    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var lblDate: UILabel!

    @IBOutlet weak var viewCreatedBy: UIView!
    @IBOutlet weak var lblCreatedBy: UILabel!

    @IBOutlet weak var lblAgenda: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    
    //MARK: - VARIABLES
    private let eventsVM = EventListViewModel()
    
    var eventID : String = ""
    
    //MARK: - VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()
     
        getEventDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
}

//MARK: - API Call
extension  EventDetailsVC {
    
    private func getEventDetails() {
        
        viewScreenData.isHidden = true
        
        eventsVM.getEventDetails(id: self.eventID, isShowLoader: true) { success in
            
            self.bindData()
            
        } failure: { errorResponse in
            //failure
        }
    }
    
}

//MARK: - GENERAL METHODS
extension  EventDetailsVC {
    
    private func bindData() {
        
        viewScreenData.isHidden = false
        
        if let obj = eventsVM.eventModel {
        
            lblDate.text = getStrDateFromDate(date: (obj.datetime ?? ""), fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy, hh:mm a")
        
            lblCreatedBy.text = obj.instructor?.name ?? ""
            
            lblAgenda.text = obj.agenda ?? ""
            
            lblLocation.text = obj.location?.name ?? ""
            
            lblPhoneNumber.text = "\(obj.countryCode ?? "") \(obj.mobile ?? "")"
            
            lblDescription.text = obj.descriptionField
        }
    }
    
}

