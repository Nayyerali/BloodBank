//
//  Messages.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/23/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messagebody: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
