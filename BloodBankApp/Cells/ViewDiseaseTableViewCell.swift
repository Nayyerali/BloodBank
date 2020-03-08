//
//  ViewDiseaseTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/9/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class ViewDiseaseTableViewCell: UITableViewCell {

    @IBOutlet weak var disease: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        disease.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
