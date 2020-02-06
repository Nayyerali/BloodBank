//
//  DonarsProfileViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class DonarsProfileViewController: UIViewController {
    
    
    @IBOutlet weak var donarsImage: UIImageView!
    @IBOutlet weak var donarFirstName: UITextField!
    @IBOutlet weak var donarLastName: UITextField!
    @IBOutlet weak var donarPhoneNumber: UITextField!
    @IBOutlet weak var donarEmail: UITextField!
    @IBOutlet weak var donarBloodGroup: UITextField!
    @IBOutlet weak var donarDOB: UITextField!
    @IBOutlet weak var viewDiseaseBtnOut: UIButton!
    @IBOutlet weak var requestBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donarsImage.roundedImage()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestBtnPressed(_ sender: Any) {
        self.requestBtnOut.setTitle("Cancle Request", for: UIControl.State.normal)
    }
    
    func filedsStatus () {
        donarFirstName.isEnabled = false
        donarLastName.isEnabled = false
        donarPhoneNumber.isEnabled = false
        donarEmail.isEnabled = false
        donarBloodGroup.isEnabled = false
        donarDOB.isEnabled = false
    }
    
    func setUpElements () {
        Utilities.styleHollowButton(requestBtnOut)
        Utilities.styleFilledButton(viewDiseaseBtnOut)
        Utilities.styleTextField(donarFirstName)
        Utilities.styleTextField(donarLastName)
        Utilities.styleTextField(donarPhoneNumber)
        Utilities.styleTextField(donarEmail)
        Utilities.styleTextField(donarBloodGroup)
        Utilities.styleTextField(donarDOB)
    }
}
