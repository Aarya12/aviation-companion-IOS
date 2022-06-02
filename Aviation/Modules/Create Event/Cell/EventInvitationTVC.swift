//
//  EventInvitationTVC.swift
//  Aviation
//
//  Created by Zestbrains on 23/11/21.
//

import UIKit

class EventInvitationTVC: UITableViewCell {


    //MARK: - IBOutlets
    @IBOutlet weak var lblEmail: UILabel!
    
    //MARK: - VARIABLES
    var btnCloser : buttonActionAlias?

    //MARK: - Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnRemoveClicks(_ sender: UIButton) {
        btnCloser?(sender)
    }
}
