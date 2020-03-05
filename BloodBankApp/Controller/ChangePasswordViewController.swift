//
//  ChangePasswordViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/4/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var updatePasswordButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func validateFields() -> String? {
        
        if currentPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please Fill All Fields"
        }
        
        let safePassword = newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if newPassword.text != confirmNewPassword.text {
            return "New Password & Confirm Password Does Not Match"
        }
        if Utilities.changePasswordValid(safePassword!) == false {
            // password Is not Secured in
            return "Please make sure your password is at least 8 characters long containing special character and a number."
        } else {
            return nil
        }
    }
    
    var passwordToggle = true
    
    @IBAction func passwordVisibility(_ sender: Any) {
        
        if (passwordToggle == true) {
            
            currentPassword.isSecureTextEntry = false
            newPassword.isSecureTextEntry = false
            confirmNewPassword.isSecureTextEntry = false
        } else {
            currentPassword.isSecureTextEntry = true
            newPassword.isSecureTextEntry = true
            confirmNewPassword.isSecureTextEntry = true
        }
        passwordToggle = !passwordToggle
    }
    
    func showError (_ message:String) {
        
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
    @IBAction func updatePasswordBtn(_ sender: Any) {
        
        
        let error = validateFields()
        if error != nil {
            // There is something wrong with fields
            showError(error!)
            return
        }
        
        currentPassword.isEnabled = false
        newPassword.isEnabled = false
        confirmNewPassword.isEnabled = false
        
        
        changePassword(email: User.userSharefReference.email, currentPassword: currentPassword.text!, newPassword: newPassword.text!) { (error) in
            if error == nil {
                
                self.showAlert(controller: self, title: "Success", message: "Password Changed Successfully") { (Ok) in
                    self.showAlert(controller: self, title: "Confirmation", message: "Please Login With Updated Password") { (Ok) in
                        
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
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            }
            else {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        Utilities.styleTextField(currentPassword)
        Utilities.styleTextField(newPassword)
        Utilities.styleTextField(confirmNewPassword)
        Utilities.styleFilledButton(updatePasswordButtonOut)
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
