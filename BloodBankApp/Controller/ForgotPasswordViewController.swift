//
//  ForgotPasswordViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/4/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var retrievePassBtnOut: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func retreivePasswordBtn(_ sender: Any) {
        
    }
    
    func setUpElements (){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailAddress)
        Utilities.styleFilledButton(retrievePassBtnOut)
    }
}
