//
//  TJBVendorOptionsListTableViewCell.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/21/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBVendorOptionsListTableViewCell: UITableViewCell {

    @IBOutlet weak var vendorSymbolImage: UIImageView!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var checkBox: TJBCheckBox!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        selectionStyle = .none
    }
    
    func configure(vendorType: TJBVendor.VendorType) {
        // symbol image
        vendorSymbolImage.contentMode = .scaleAspectFit
        vendorSymbolImage.image = vendorType.mapSymbol
        
        // vendor name
        vendorNameLabel.text = vendorType.stringRepresentation
    }
    
    func toggleCheckMark() {
        checkBox.isChecked = !checkBox.isChecked
    }
}
