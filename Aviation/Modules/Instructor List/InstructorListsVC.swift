//
//  InstructorListsVC.swift
//  Aviation
//
//  Created by Zestbrains on 16/12/21.
//

import UIKit

class InstructorListsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField! {
        didSet {
            txtSearch.delegate = self
            txtSearch.clearButtonMode = .always
        }
    }
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!

    @IBOutlet weak var collectionInstructors: UICollectionView!


    //MARK: - VARIABLES
    var isFromScreen : isFrom = .HomeViewAll
    private var instructorVM = InstructorViewModel()
    private var isDataLoading : Bool = false

    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionInstructors.registerCell(type: InstructorsCVC.self)
        collectionInstructors.registerCell(type: LoadingCVC.self)

        collectionInstructors.setDefaultProperties(vc: self)
        
        LocationManager.shared.getLocation(vc: self) { (clLocation, error) in
            
            self.instructorVM.latitude = clLocation?.coordinate.latitude ?? 0
            self.instructorVM.longitude = clLocation?.coordinate.longitude ?? 0
         
            self.setupInitialData()
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewSearch.Round = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
    
    
    @IBAction func btnSearchClicks(_ sender: Any) {
        
    }

    @IBAction func btnFilterClicks(_ sender: Any) {
        
        let vc = storyBoards.Student.instantiateViewController(withIdentifier: "FilterInstructorPopupVC") as! FilterInstructorPopupVC
        vc.delegate = self
        vc.strSelectedExperience = instructorVM.experience
        vc.strSelectedPrice = instructorVM.price
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }

}


//MARK: - COLLECTIONVIEW METHODS
extension  InstructorListsVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if instructorVM.hasMoreData {
            return 2
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return instructorVM.arrInstructors.count
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructorsCVC", for: indexPath) as?  InstructorsCVC {
                
                if instructorVM.arrInstructors.count > indexPath.row {
                    
                    cell.bindData(obj: instructorVM.arrInstructors[indexPath.row])
                    
                }
                return cell
            }
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCVC", for: indexPath) as?  LoadingCVC {
                cell.startLoading()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            var width : CGFloat = 0
            if IS_IPAD_DEVICE() {
                width = (collectionView.frame.size.width - 90)/2
            }else {
                width = (collectionView.frame.size.width - 30)
            }
            return CGSize(width: width, height: 150.0)
        }else {
            let width : CGFloat = (collectionView.frame.size.width - 30)
            return CGSize(width: width, height: 80.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        if indexPath.section == 0 {
            let vc = storyBoards.Home.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.instructurId = (instructorVM.arrInstructors[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - TEXTFIELD DELEGATEs
extension InstructorListsVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if !textField.text!.isEmpty {
            setupInitialData()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        setupInitialData()
        
        return false
    }
}

//MARK: - Pagination
extension InstructorListsVC {
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionInstructors {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 350 {
                
                if !isDataLoading {
                    isDataLoading = true

                    if self.instructorVM.hasMoreData {
                        
                        GetAllInstructor(isShowLoader: false)
                    }
                }
            }
        }
    }

}

//MARK: - GENERAL METHODS
extension  InstructorListsVC {
    
    private func GetAllInstructor(isShowLoader : Bool = true) {
        
        instructorVM.getAllInstructor(isShowLoader: isShowLoader) { response in
            
            self.isDataLoading = false
            self.collectionInstructors.reloadData()
            
        } failure: { errorResponse in
            
            self.isDataLoading = false
            self.collectionInstructors.reloadData()
        }
        
    }

}


//MARK: - GENERAL METHODS
extension  InstructorListsVC {
    
    func setupInitialData() {
        self.view.endEditing(true)
        instructorVM.strSearch = txtSearch.text ?? ""
        
        //Getting the current location
        LocationManager.shared.getLocation(vc: self) { location, error in
            
            self.instructorVM.latitude = location?.coordinate.latitude ?? 0

            self.instructorVM.latitude = location?.coordinate.longitude ?? 0

            self.instructorVM.offset = 0
            self.GetAllInstructor()
        }
    }
}

//MARK: - InsturctorFilterDelegate
extension  InstructorListsVC : InsturctorFilterDelegate {
    
    func didSelectFilters(experience: String, price: String) {
        self.instructorVM.experience = experience
        self.instructorVM.price = price
        
        self.setupInitialData()
    }
    
    func resetFilter() {
        self.instructorVM.experience = ""
        self.instructorVM.price = ""
        
        self.setupInitialData()
    }
}

