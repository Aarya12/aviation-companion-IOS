//
//  HomeEventsCVC.swift
//  Aviation
//
//  Created by Zestbrains on 15/11/21.
//

import UIKit

class HomeEventsCVC: UICollectionViewCell {

    @IBOutlet weak var lblEventDay: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var btnReschedule: UIButton!
    
    var delegate : HomeCellsDelegate?
    var indexPath : IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func btnEditClicks(_ sender: UIButton) {
        self.delegate?.didSelectCollectionCell(section: 1, selected: indexPath)
    }
}


//MARK: - GENERAL METHODS
extension  HomeEventsCVC {
    
    func bindData(obj : ModelHomeEvent) {
        
        let strDate = obj.datetime ?? ""
        
        lblEventDay.text = timeToNextDays(getDateFromString(date: strDate, fromFormate: "yyyy-MM-dd HH:mm:ss"))
        
        //self.arrEventStudents = obj.joinedStudents
        
        lblEventTitle.text = obj.agenda
        
        lblLocation.text = obj.location?.name
 
        lblDate.text = getStrDateFromDate(date: strDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd,yyyy")
        lblTime.text = getStrDateFromDate(date: strDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "hh:mm a")
    }
}

