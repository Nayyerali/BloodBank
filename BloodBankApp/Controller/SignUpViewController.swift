//
//  SignUpViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bloodGroup: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    private var datePicker: UIDatePicker?
    
    let pickerView = UIPickerView()
    var bloodTypes = ["A+","A-","B+","B-","AB+","AB-","O-","O+"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //passwordFieldsMatch()
        placeHolderImage.roundedImage()
        pickerView.delegate = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
        bloodGroup.inputView = pickerView
        datePickerView ()
        elements()
        addGesture()
    }
    
    var passwordToggle = true
    
    @IBAction func confirmPassVisibility(_ sender: Any) {
        
        if (passwordToggle == true) {
            confirmPassword.isSecureTextEntry = false
        } else {
            confirmPassword.isSecureTextEntry = true
        }
        passwordToggle = !passwordToggle
    }
    
    @IBAction func passVIsibility(_ sender: UIButton) {
        
        if (passwordToggle == true) {
            password.isSecureTextEntry = false
        } else {
            password.isSecureTextEntry = true
        }
        passwordToggle = !passwordToggle
    }
    
    func validateFields() -> String? {
        // check for all fields are filled or not
        if
            //password.text != confirmPassword.text ||
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                PhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                bloodGroup.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                dateOfBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in the blanks"
        }
        // Check for strong Password
        
        let safePassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.text != confirmPassword.text {
            return "Passwords Does Not Match"
        }
        if Utilities.isPasswordValid(safePassword!) == false {
            // password Is not Secured in
            return "Please make sure your password is at least 8 characters long containing special character and a number."
        } else {
            return nil
        }
    }
    
    func showError (_ message:String) {
        
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
    func datePickerView () {
        //creatDatePicker()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateOfBirth.inputView = datePicker
        //datePicker?.tintColor = .clear
        datePicker?.addTarget(self, action: #selector(SignUpViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGasture)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        toolBar.setItems([cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateOfBirth.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            // There is something wrong with fields
            showError(error!)
            return
        }
        
        CustomLoader.instance.showLoaderView()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: password.text!) { authResult, error in
            
            if error == nil{
                // account created
                print(authResult?.user.uid)
                ServerCommunication.sharedDelegate.uploadImage(image: self.placeHolderImage.image!, userId: (authResult?.user.uid)!) { (status, response) in
                    if status{
                        // Image uploaded
                        
                        let newUser = User(firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, dateOfBirth: self.dateOfBirth.text!, bloodGroup: self.bloodGroup.text!, phoneNumber: self.PhoneNumber.text!, email: self.emailTextField.text!, userId: ((authResult?.user.uid)!), imageUrl: response)
                        
                        // Assign current user while creating account
                        User.userSharefReference = newUser
                        
                        ServerCommunication.sharedDelegate.uploadUserData(userData: newUser.getUserDict()) { (status, message) in
                            
                            if status{
                                
                                CustomLoader.instance.hideLoaderView()
                                // Move to Home screen
                                self.navigationController?.setNavigationBarHidden(true, animated: false)
                                self.performSegue(withIdentifier: "toDashboard", sender: nil)
                            }else{
                                CustomLoader.instance.hideLoaderView()
                                self.showAlert(controller: self, title: "Error", message: message) { (ok) in
                                    // ok button pressed
                                }
                            }
                        }
                    }else{
                        CustomLoader.instance.hideLoaderView()
                        self.showAlert(controller: self, title: "Error", message: response) { (ok) in
                            // Ok button pressed
                        }
                    }
                }
            }else{
                CustomLoader.instance.hideLoaderView()
                print(error?.localizedDescription)
            }
        }
    }
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        placeHolderImage.addGestureRecognizer(gesture)
        placeHolderImage.isUserInteractionEnabled = true
    }
    
    @objc func userImageTapped(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (ok) in
            // Camera option tapped
            self.presentImagePicker(type: .camera)
            self.modalPresentationStyle = .fullScreen
        }
        
        let photoGallery = UIAlertAction(title: "Gallery", style: .default) { (gallery) in
            // Gallery option tapped
            self.presentImagePicker(type: .photoLibrary)
            self.modalPresentationStyle = .fullScreen
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            // Cancel Tapped
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoGallery)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentImagePicker(type:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func elements () {
        
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(PhoneNumber)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(bloodGroup)
        Utilities.styleTextField(dateOfBirth)
        Utilities.styleTextField(password)
        Utilities.styleTextField(confirmPassword)
        Utilities.styleHollowButton(signUpBtn)
        // placeHolderImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
    }
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.placeHolderImage.image = image
        self.dismiss(animated: true, completion: nil)
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

extension SignUpViewController:UIPickerViewDelegate,UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodGroup.text = bloodTypes[row]
        //bloodGroup.resignFirstResponder()
    }
    func donePicker() {
        
        bloodGroup.resignFirstResponder()
    }
}
