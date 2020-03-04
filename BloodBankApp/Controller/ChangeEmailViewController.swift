//
//  ChangeEmailViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/4/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangeEmailViewController: UIViewController {
    
    @IBOutlet weak var newEmailField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var updateEmailBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func updateEmailBtn(_ sender: Any) {
//        let reference = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").document(User.userSharefReference.userId).updateData
//            (["Email":newEmailField.text]) { (error) in
//            if error == nil {
//                self.showAlert(controller: self, title: "Success", message: "Email Address Changed Successufly") { (Ok) in
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(newEmailField)
        Utilities.styleFilledButton(updateEmailBtnOut)
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
