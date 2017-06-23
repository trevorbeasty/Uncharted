//
//  TJBCheckBox.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/23/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBCheckBox: UIImageView {
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                image = #imageLiteral(resourceName: "CheckMark")
            } else {
                image = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonPostInitLogic()
    }
    
    private func commonPostInitLogic() {
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        
        contentMode = .scaleAspectFit
    }
}
