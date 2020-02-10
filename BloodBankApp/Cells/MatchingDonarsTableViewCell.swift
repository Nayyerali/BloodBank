//
//  MatchingDonarsTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/24/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class MatchingDonarsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var donarImage: UIImageView!
    @IBOutlet weak var donarUserName: UITextField!
    @IBOutlet weak var donarBloodGroup: UITextField!
    @IBOutlet weak var internelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        donarUserName.isEnabled = false
        donarBloodGroup.isEnabled = false
        elements()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func elements () {
        donarImage.roundedImage()
        Utilities.styleTextField(donarUserName)
        Utilities.styleTextField(donarBloodGroup)
        internelView.layer.cornerRadius = 15.0
        internelView.layer.borderWidth = 5.0
        internelView.layer.borderColor = UIColor.black.cgColor
    }
}
