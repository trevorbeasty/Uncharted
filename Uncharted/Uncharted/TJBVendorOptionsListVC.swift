//
//  TJBVendorOptionsListVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/21/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBVendorOptionsListVC: UIViewController {

    var vendorOptions: [TJBVendor.VendorType]?
    let vendorOptionsListTVC_ID: String = "TJBVendorOptionsListTableViewCell"
    
    @IBOutlet weak var vendorList: UITableView!
    
    init(vendorOptions: [TJBVendor.VendorType]) {
        self.vendorOptions = vendorOptions
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        vendorOptions = nil
        
        super.init(coder: aDecoder)
    }
    
    // view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorList.delegate = self
        vendorList.dataSource = self
        let customCellNib = UINib(nibName: "TJBVendorOptionsListTableViewCell", bundle: nil)
        vendorList.register(customCellNib, forCellReuseIdentifier: vendorOptionsListTVC_ID)
    }

}

extension TJBVendorOptionsListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vendorOptions != nil { return vendorOptions!.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = vendorOptions?[indexPath.row]
            else { return UITableViewCell() }
        
        if let dequeuedCell = vendorList.dequeueReusableCell(withIdentifier: vendorOptionsListTVC_ID) as? TJBVendorOptionsListTableViewCell{
            
            dequeuedCell.configure(vendorType: type)
            return dequeuedCell
            
        } else {
            if let nibObjects = Bundle.main.loadNibNamed("TJBVendorOptionsListTableViewCell",
                                                            owner: self,
                                                            options: nil),
            let newCell = nibObjects[0] as? TJBVendorOptionsListTableViewCell {
                
                newCell.configure(vendorType: type)
                return newCell
                
            } else {
                return UITableViewCell()
            }
        }
    }
}

extension TJBVendorOptionsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = vendorList.cellForRow(at: indexPath) as? TJBVendorOptionsListTableViewCell {
            cell.toggleCheckMark()
        }
    }
}










