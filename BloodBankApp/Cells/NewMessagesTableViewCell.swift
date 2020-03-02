//
//  NewMessagesTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/24/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class NewMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactUserName: UILabel!
    @IBOutlet weak var contactBloodGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactImage.roundedImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
