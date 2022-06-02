//
//  HomeHeaderTVC.swift
//  Aviation
//
//  Created by Zestbrains on 12/11/21.
//

import UIKit

protocol HomeCellsDelegate {
    func didSelectSeeAll(section : Int)
    func didSelectCollectionCell(section : Int , selected indexPath : IndexPath)
    
}

class HomeHeaderTVC: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnSeeAll: UIButton!
    
    //MARK: - VARIABLES
    var section : Int = 0
    var delegate : HomeCellsDelegate?
    
    //MARK: - Cell methods
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - button actions
    @IBAction func btnSeeAllActions(_ sender: Any) {
        
        self.delegate?.didSelectSeeAll(section: self.section)
        
    }
    
}
