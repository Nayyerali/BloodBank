//
//  ForgotPasswordViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/4/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var retrievePassBtnOut: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func retreivePasswordBtn(_ sender: Any) {
        
        if emailAddress.text?.isEmpty == true{
            errorLabel.alpha = 1
            errorLabel.text = "Please enter your email"
        }else{
            Auth.auth().sendPasswordReset(withEmail: emailAddress.text!) { (error) in
                
                if let error = error {
                    
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = error.localizedDescription
                }else{
                    self.emailAddress.isEnabled = false
                    self.showAlert(controller: self, title: "Email Sent", message: "Password recovery email is sent to your Email Address") { (ok) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func setUpElements (){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailAddress)
        Utilities.styleFilledButton(retrievePassBtnOut)
    }
    
    func showAlert(controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            // ok button press
            completion(true)
        }
        alerController.addAction(okAction)
        controller.present(alerController, animated: true)
    }
}
