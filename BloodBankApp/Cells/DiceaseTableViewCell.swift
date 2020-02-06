//
//  DiceaseTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/29/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class DiceaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var diseasesTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        diseasesTextField.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
