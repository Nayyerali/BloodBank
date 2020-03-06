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
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    var credential: AuthCredential?
    
    @IBAction func updateEmailBtn(_ sender: Any) {
        
        changeEmail(newEmail: newEmailField.text!, oldEmail: User.userSharefReference.email, userPassword: passwordField.text!) { (error) in
            
            if error == nil {
                let reference = ServerCommunication.sharedDelegate.firebaseFirestore.collection("Users").document(User.userSharefReference.userId).updateData(["Email":self.newEmailField.text!]) {(error) in
                    
                    if error == nil {
                        self.showAlert(controller: self, title: "Success", message: "Email Address Changed Successfully") { (Ok) in
                            self.showAlert(controller: self, title: "Confirmation", message: "Please Login With Updated Email Address") { (Ok) in
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    User.userSharefReference = nil
                                    self.navigationController?.navigationController?.popToRootViewController(animated: true)
                                } catch let signOutError as NSError {
                                    print ("Error signing out: %@", signOutError)
                                }
                            }
                        }
                    } else {
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = error?.localizedDescription
                    }
                }
            } else {
                self.errorLabel.alpha = 1
                self.errorLabel.text = error?.localizedDescription
            }
        }
    }
    
    func changeEmail(newEmail: String, oldEmail: String, userPassword: String, completion: @escaping (Error?) -> Void) {
        let credentials = EmailAuthProvider.credential(withEmail: oldEmail, password: userPassword)
        
        
        Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { (result, error) in
            if let error = error {
                completion(error)
            }
            else {
                Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
    
    var passwordToggle = true
    
    @IBAction func passwordVisibilty(_ sender: Any) {
        
        if (passwordToggle == true) {
            
            passwordField.isSecureTextEntry = false

        } else {
            passwordField.isSecureTextEntry = true

        }
        passwordToggle = !passwordToggle
    }
    
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(newEmailField)
        Utilities.styleTextField(passwordField)
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
