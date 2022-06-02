//
//  AviationListView.swift
//  Aviation
//
//  Created by Zestbrains on 22/12/21.
//

import UIKit

protocol SelectAviationDelegate {
    func didSelectAviation(avition : ModelProfileAirport)
}

class AviationLVW : UIView {
    
    var vw : AviationListView = AviationListView.fromNib()
    var delegate : SelectAviationDelegate? {
        get {
            return nil
        }
        set {
            vw.delegate = newValue
        }
    }
    
    var arrAviations : [ModelProfileAirport] = [] {
        didSet {
            vw.arrAviations = self.arrAviations
            self.isHidden = (arrAviations.count == 0)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadNib()
    }
    
    private func loadNib() {
        print("loadNib() ")
        self.addSubview(vw)

        vw.delegate = delegate
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: vw, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: vw, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: vw, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: vw, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ])

    }
}


class AviationListView: UIView {
    
    @IBOutlet weak var tblAviations: UITableView! {
        didSet {
            tblAviations.delegate = self
            tblAviations.dataSource = self
        }
    }

    //MARK: - VARIABLES
    var delegate : SelectAviationDelegate?
    
    var arrAviations : [ModelProfileAirport] = [] {
        didSet {
            if arrAviations.count == 0{
                tblAviations.setEmptyMessage("Airports not founds!")
            }else{
                tblAviations.restore()
            }
            tblAviations.separatorStyle = .none
            self.tblAviations.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tblAviations.delegate = self
        
        tblAviations.registerCell(type: AviationsListTVC.self)
    }

    func instanceFromNib() -> AviationListView {
        return UINib(nibName: "AviationListView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AviationListView
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AviationListView : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrAviations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AviationsListTVC") as? AviationsListTVC{
            
            cell.lblTitle.text = "\(arrAviations[indexPath.row].name ?? "") (\(arrAviations[indexPath.row].localCode ?? ""))"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.didSelectAviation(avition: arrAviations[indexPath.row])
    }
}


extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
