//
//  HomeTVC.swift
//  Aviation
//
//  Created by Zestbrains on 12/11/21.
//

import UIKit

class HomeTVC: UITableViewCell {

    @IBOutlet weak var collectionDatas: UICollectionView!
    
    @IBOutlet weak var ConstraintCollectionHeight: NSLayoutConstraint!
    
    //MARK: -
    var gridCellSize : CGSize = CGSize.zero {
        didSet {
            collectionDatas.reloadData()
        }
    }
    
    var delegate : HomeCellsDelegate?
    var section : Int = 0
    var homeModel : ModelHomeMain?

    //MARK :- UITableViewCell functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        collectionDatas.registerCell(type: HomeNotesCVC.self)
        
        collectionDatas.registerCell(type: HomeEventsCVC.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//MARK: - COLLECTIONVIEW METHODS
extension  HomeTVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let homeObj = homeModel else { return 0 }

        if self.section == 0 {
            
            if homeObj.users.count == 0 {
                if AppSelectedUserType == .Student {
                    collectionView.setEmptyMessage("No instructors found!")
                }else {
                    collectionView.setEmptyMessage("No students found!")
                }
            }else {
                collectionView.restore()
            }
            
            return homeObj.users.count
            
        }else{
            if homeObj.events.count == 0 {
                collectionView.setEmptyMessage("No events found!")
            }else {
                collectionView.restore()
            }

            return homeObj.events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNotesCVC", for: indexPath) as?  HomeNotesCVC {
                
                if let homeObj = homeModel, homeObj.users.count > indexPath.row {
                    cell.bindData(obj: homeObj.users[indexPath.row])
                }
                
                cell.layoutIfNeeded()

                return cell
            }
        }else {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeEventsCVC", for: indexPath) as?  HomeEventsCVC {
                
                if AppSelectedUserType == .Student {
                    cell.btnReschedule.isHidden = true
                }else {
                    cell.btnReschedule.isHidden = false
                }
                
                if let homeObj = homeModel, homeObj.events.count > indexPath.row {
                    
                    cell.bindData(obj: homeObj.events[indexPath.row])
                    
                }
                
                cell.delegate = delegate
                cell.indexPath = indexPath
                cell.layoutIfNeeded()
                return cell
            }

        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return gridCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.didSelectCollectionCell(section: self.section, selected: indexPath)
    }
}

