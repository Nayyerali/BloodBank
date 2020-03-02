//
//  SignInViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passBtnOut: UIButton!
    
    let emailImage = UIImage(named: "Email Icon")
    let passwordImage = UIImage(named: "Password Icon")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elements()
        // Do any additional setup after loading the view.
    }
    
    func textFieldsImages (textField: UITextField, imageIcon: UIImage) {
        
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: imageIcon.size.width, height: imageIcon.size.height))
        leftImageView.image = imageIcon
        leftImageView.contentMode = .center
        textField.leftView = leftImageView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    var passwordToggle = true
    
    @IBAction func passBtn(_ sender: Any) {
        
        if (passwordToggle == true) {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        passwordToggle = !passwordToggle
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        CustomLoader.instance.showLoaderView()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            
            if error == nil{
                //User loggedin
                // Funtionality is to identify which user is logged in using user ID which is coming from auth result
                ServerCommunication.sharedDelegate.fetchUserData(userId: (authResult?.user.uid)!) { (status, message, user) in
                    if status{
                        // Assign user while login
                        
                        // if user is already logged in there fore keeping user reference on sign in
                        User.userSharefReference = user!
                        print(authResult?.user.uid)
                        CustomLoader.instance.hideLoaderView()
                        self?.navigationController?.setNavigationBarHidden(true, animated: true)
                        self?.performSegue(withIdentifier: "toDashboard", sender: nil)
                    }else{
                        CustomLoader.instance.hideLoaderView()
                        self?.showAlert(controller: self!, title: "Failure", message: message, actiontitle: "Ok", completion: { (okButtonPressed) in
                            
                        }
                        )
                    }
                }
            }else{
                
                self!.errorLabel.alpha = 1
                self!.errorLabel.text = error?.localizedDescription
                return
                CustomLoader.instance.hideLoaderView()
                print(error?.localizedDescription)
            }
        }
    }
    
    func elements () {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInBtn)
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
    
    func showAlert(controller:UIViewController,title:String,message:String,actiontitle:String,completion:@escaping(_ okBtnPressed:Bool)->Void){
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: actiontitle, style: .destructive) { (alertAction) in
            // ok button press
            completion(true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            // ok button press
            completion(false)
        }
        alerController.addAction(delete)
        alerController.addAction(cancel)
        controller.present(alerController, animated: true)
    }
}
