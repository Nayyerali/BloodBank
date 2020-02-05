//
//  ImageViewDesign.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/3/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundedImage () {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

