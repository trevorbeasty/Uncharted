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
    @IBOutlet weak var checkBoxButton: UIButton!
    
    func configure(vendorType: TJBVendor.VendorType) {
        vendorSymbolImage.image = vendorType.mapSymbol
        vendorNameLabel.text = vendorType.stringRepresentation
    }
}
