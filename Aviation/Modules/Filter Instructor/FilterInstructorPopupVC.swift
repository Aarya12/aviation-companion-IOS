//
//  FilterInstructorPopupVC.swift
//  Aviation
//
//  Created by Zestbrains on 15/12/21.
//

import UIKit
import BottomPopup

protocol InsturctorFilterDelegate {
    func didSelectFilters(experience : String , price : String)
    func resetFilter()
}

class FilterInstructorPopupVC : UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var collectionExperiances: UICollectionView!
    
    @IBOutlet weak var ConstraintPriceLeading: NSLayoutConstraint!
    @IBOutlet weak var sliderPrice: UISlider!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnApply: EMButton! {
        didSet {
            btnApply.btnType = .Submit
        }
    }
    
    @IBOutlet weak var btnReset: UIButton!

    //MARK: - VARIABLES
    var arrExperience : [experience] = []
    
    struct experience {
        var display : String = ""
        var sendToAPI : String = ""
    }
    
    var selectedExperience : Int?
    var delegate : InsturctorFilterDelegate?

    var strSelectedExperience : String = ""
    var strSelectedPrice : String = ""
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionExperiances.registerCell(type: TagsCVC.self)

        collectionExperiances.setDefaultProperties(vc: self)
        
        arrExperience = [
            experience(display: "1+ Year", sendToAPI: "1"),
            experience(display: "2+ Year", sendToAPI: "2"),
            experience(display: "3+ Year", sendToAPI: "3"),
            experience(display: "4+ Year", sendToAPI: "4"),
            experience(display: "5+ Year", sendToAPI: "5"),
            experience(display: "6+ Year", sendToAPI: "6"),
            experience(display: "7+ Year", sendToAPI: "7"),
            experience(display: "8+ Year", sendToAPI: "8"),
            experience(display: "9+ Year", sendToAPI: "9"),
            experience(display: "10+ Year", sendToAPI: "10"),
            experience(display: "11+ Year", sendToAPI: "11"),
            experience(display: "12+ Year", sendToAPI: "12"),
            experience(display: "13+ Year", sendToAPI: "13"),
            experience(display: "14+ Year", sendToAPI: "14"),
            experience(display: "15+ Year", sendToAPI: "15")
        ]
        
        
        self.sliderPrice.value = Float(strSelectedPrice.integerValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setSliderLabel(sender: self.sliderPrice)
        }

        if let indexOfSelected = arrExperience.firstIndex(where: {$0.sendToAPI == strSelectedExperience}) {
            self.selectedExperience = indexOfSelected
        }
        collectionExperiances.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionExperiances.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnDismissClicks(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func btnApplyClicks(_ sender: Any) {
        
        var experience = ""
        if let selectedIndex = selectedExperience {
            experience = arrExperience[selectedIndex].sendToAPI
        }
        
        let price = ((sliderPrice.value).rounded() as NSNumber).intValue
        self.delegate?.didSelectFilters(experience: experience, price: price.description)
        self.dismiss(animated: true)
    }

    @IBAction func btnResetClicks(_ sender: Any) {
        
        self.delegate?.resetFilter()
        
        self.dismiss(animated: true)
    }

    @IBAction func sliderChanges(_ sender: UISlider) {
        
        /*
        let trackRect = sender.trackRect(forBounds: sender.bounds)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)

        lblPrice.text = appCurrency + "\(((sender.value).rounded()).description.integerValue)"
        
        let lblWidth = lblPrice.frame.size.width

        print("thumbRect.origin.x" , thumbRect.origin.x)
        print("(lblPrice.superview?.frame.size.width ?? 0.0)", (lblPrice.superview?.frame.size.width ?? 0.0))
        print("lblWidth" , lblWidth)

        if ((lblPrice.superview?.frame.size.width ?? 0.0) - lblWidth) > (thumbRect.origin.x) {
            ConstraintPriceLeading.constant = thumbRect.origin.x
        }else {
            ConstraintPriceLeading.constant = ((lblPrice.superview?.frame.size.width ?? 0.0) - lblWidth)
        }*/
        setSliderLabel(sender: sender)
    }
    
    func setSliderLabel(sender : UISlider) {
        
        let trackRect = sender.trackRect(forBounds: sender.bounds)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)

        lblPrice.text = appCurrency + "\(((sender.value).rounded()).description.integerValue)"
        
        let lblWidth = lblPrice.frame.size.width

        print("thumbRect.origin.x" , thumbRect.origin.x)
        print("(lblPrice.superview?.frame.size.width ?? 0.0)", (lblPrice.superview?.frame.size.width ?? 0.0))
        print("lblWidth" , lblWidth)

        if ((lblPrice.superview?.frame.size.width ?? 0.0) - lblWidth) > (thumbRect.origin.x) {
            ConstraintPriceLeading.constant = thumbRect.origin.x
        }else {
            ConstraintPriceLeading.constant = ((lblPrice.superview?.frame.size.width ?? 0.0) - lblWidth)
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension  FilterInstructorPopupVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrExperience.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVC", for: indexPath) as?  TagsCVC {
            
            cell.lblTags.text = arrExperience[indexPath.row].display
            cell.isShowRemoveBtn = false
            
            if self.selectedExperience == indexPath.row {
                cell.viewTagsBG.backgroundColor = .appColor
                cell.lblTags.textColor = .white
                
            }else {
                
                cell.viewTagsBG.backgroundColor = hexStringToUIColor(hex: "#C4C4C4")
                cell.lblTags.textColor = .black
                
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedExperience = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: collectionView.frame.size.height))
        
        lbl.numberOfLines = 1
        lbl.font = Font(.installed(.Regular), size: .standard(.h513)).instance
        
        lbl.text = arrExperience[indexPath.row].display
        lbl.sizeToFit()
        lbl.frame.size.height = collectionView.frame.size.height
        
        let spacing : CGFloat = 20
        //let deleteBtnSize : CGFloat = 0 //collectionView.frame.size.height - if there is remove button show
        
        return CGSize(width: lbl.frame.size.width + (spacing * 2), height: (collectionView.frame.size.height - 20))
    }
}

