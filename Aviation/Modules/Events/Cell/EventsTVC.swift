//
//  EventsTVC.swift
//  Aviation
//
//  Created by Zestbrains on 22/11/21.
//

import UIKit

class EventsTVC: UITableViewCell {
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var lblEventDay: UILabel!
    
    @IBOutlet weak var lblEventTitle: UILabel!
    
    @IBOutlet weak var lblEventDate: UILabel!
    
    @IBOutlet weak var lblEventTime: UILabel!
    
    @IBOutlet weak var lblEventLocation: UILabel!
    
    @IBOutlet weak var viewUsers: UIView!

    @IBOutlet var imageUsers: [UIImageView]!
    @IBOutlet weak var lblExtraImages: UILabel!
    
    @IBOutlet weak var btnRechedule: UIButton!
    
    var btnCloser : buttonActionAlias?
    
    var arrEventStudents : [ModelEventsJoinedStudent] = []
    /*{
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.viewUsers.reloadData()
            }
        }
    }
    */
    
    //MARK: - cell functions
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        if AppSelectedUserType == .Student {
            btnRechedule.isHidden = true
            
        }else {
            btnRechedule.isHidden = false
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnRescheduleClicks(_ sender: UIButton) {
        btnCloser?(sender)
    }
 
    
}


//MARK: - GENERAL METHODS
extension  EventsTVC {
    
    func bindData(obj : ModelEventsMain) {
        let strDate = obj.datetime ?? ""
        
        lblEventDay.text = timeToNextDays(getDateFromString(date: strDate, fromFormate: "yyyy-MM-dd HH:mm:ss"))
        
        self.arrEventStudents = obj.joinedStudents
        
        imageUsers.forEach { imgU in
            imgU.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                imgU.cornerRadius = (imgU.frame.size.height/2)
            }
        }
        for i in 0..<arrEventStudents.count {
            if i > 2 {
                lblExtraImages.text = "+\(arrEventStudents.count - 3)"
                break
            }else {
                imageUsers[i].isHidden = false
                imageUsers[i].kf.indicatorType = .activity
                imageUsers[i].kf.setImage(with: URL(string: arrEventStudents[i].studentId?.profileImage ?? ""), placeholder: UIImage(named: "ic_user_placeholder"), options: nil, completionHandler: nil)
            }
        }
        
        lblEventTitle.text = obj.agenda
        
        lblEventLocation.text = obj.location?.name
 
        lblEventDate.text = getStrDateFromDate(date: strDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd,yyyy")
        lblEventTime.text = getStrDateFromDate(date: strDate, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "hh:mm a")
    }
}
