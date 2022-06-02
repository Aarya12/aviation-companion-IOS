//
//  StudentNotesTVC.swift
//  Aviation
//
//  Created by Zestbrains on 19/11/21.
//

import UIKit

class StudentNotesTVC: UITableViewCell {

    @IBOutlet weak var lblNotesDate: UILabel!
        
    @IBOutlet weak var collectionTags: UICollectionView!
    
    @IBOutlet weak var lblNote: UILabel!
    
    var arrTags : [String] = ["#take-off" , "#new" , "#database", "#take-off" , "#new" , "#database" , "#take-off" , "#new" , "#database", "#take-off" , "#new" , "#database", "#take-off" , "#new" , "#database"]
    
    //MARK: - Cell function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        collectionTags.registerCell(type: TagsCVC.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(obj : ModelStudentNotes) {
        lblNotesDate.text =  getStrDateFromDate(date: obj.datetime ?? "", fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd-MMM-yyyy, hh:mm a")
        lblNote.text = obj.note
        
        arrTags.removeAll()
        arrTags = obj.tags.components(separatedBy: ",")
        collectionTags.reloadData()
    }
    
}

//MARK: - COLLECTIONVIEW METHODS
extension  StudentNotesTVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVC", for: indexPath) as?  TagsCVC {
            
            cell.lblTags.text = arrTags[indexPath.row]
            cell.isShowRemoveBtn = false
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
        
        return CGSize(width: lbl.frame.size.width + (spacing * 2), height: collectionView.frame.size.height)
    }
}

