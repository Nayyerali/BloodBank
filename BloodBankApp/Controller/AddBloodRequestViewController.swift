//
//  AddBloodRequestViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/8/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class AddBloodRequestViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var requiredBlood: UITextField!
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    let pickerView = UIPickerView()
    var bloodTypes = ["A+","A-","B+","B-","AB+","AB-","O-","O+"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(requiredBlood)
        Utilities.styleFilledButton(addBtnOutlet)
        pickerView.delegate = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
        requiredBlood.inputView = pickerView
        
        // Do any additional setup after loading the view.
    }
    
    var addBloodRequests : addBloodRequestProtocol?
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        ServerCommunication.sharedDelegate.requestdBlood(bloodGroup: requiredBlood.text!, imageUrl: User.userSharefReference.imageUrl, name: User.userSharefReference.firstName) { (status, message) in
            if status {
                self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlert(controller: self, title: "Failed", message: message) { (ok) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        print ("")
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
        requiredBlood.text = bloodTypes[row]
        //bloodGroup.resignFirstResponder()
    }
    func donePicker() {
        
        requiredBlood.resignFirstResponder()
    }
}
