//
//  RequestBloodTableViewCell.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/8/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class RequestBloodTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var requiredBlood: UITextField!
    @IBOutlet var internelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpEmelemnts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpEmelemnts(){
        userImage.roundedImage()
        Utilities.styleTextField(userName)
        Utilities.styleTextField(requiredBlood)
        internelView.layer.cornerRadius = 15.0
        internelView.layer.borderWidth = 5.0
        internelView.layer.borderColor = UIColor.black.cgColor
    }
}
