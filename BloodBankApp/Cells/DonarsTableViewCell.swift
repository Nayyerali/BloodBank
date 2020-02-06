//
//  DonarsTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class DonarsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var donarImage: UIImageView!
    @IBOutlet weak var donarUserName: UITextField!
    @IBOutlet weak var donarBloodGroup: UITextField!
    @IBOutlet weak var reuqestBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        donarImage.roundedImage()
        donarUserName.isEnabled = false
        donarBloodGroup.isEnabled = false
        elements()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func elements () {
        Utilities.styleHollowButton(reuqestBtn)
        Utilities.styleTextField(donarUserName)
        Utilities.styleTextField(donarBloodGroup)
        //   donarImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
}
