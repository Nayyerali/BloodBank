//
//  UserProfileViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileFirstName: UITextField!
    @IBOutlet weak var profileLastName: UITextField!
    @IBOutlet weak var profilePhoneNumber: UITextField!
    @IBOutlet weak var profileEmail: UITextField!
    @IBOutlet weak var profileBloodGroup: UITextField!
    @IBOutlet weak var profileDateOfBirth: UITextField!
    @IBOutlet weak var logOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.roundedImage()
        elements()
        setupUserProfile()
        elementsEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setupUserProfile()
    }
    
    func elementsEditing() {
        profileDateOfBirth.isEnabled = false
        profileBloodGroup.isEnabled = false
        profileEmail.isEnabled = false
        profilePhoneNumber.isEnabled = false
        profileFirstName.isEnabled = false
        profileLastName.isEnabled = false
    }
    
    func setupUserProfile (){
        
        self.profileFirstName.text = User.userSharefReference.firstName
        self.profileLastName.text = User.userSharefReference.lastName
        self.profilePhoneNumber.text = User.userSharefReference.phoneNumber
        self.profileEmail.text = User.userSharefReference.email
        self.profileBloodGroup.text = User.userSharefReference.bloodGroup
        self.profileDateOfBirth.text = User.userSharefReference.dateOfBirth
        
        if let url = URL(string: User.userSharefReference.imageUrl){
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDashboard" {
            let destination = segue.destination as! UserProfileViewController
        }
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            User.userSharefReference = nil
            self.navigationController?.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func elements () {
        
        Utilities.styleHollowButton(logOutBtn)
        Utilities.styleTextField(profileFirstName)
        Utilities.styleTextField(profileLastName)
        Utilities.styleTextField(profilePhoneNumber)
        Utilities.styleTextField(profileEmail)
        Utilities.styleTextField(profileBloodGroup)
        Utilities.styleTextField(profileDateOfBirth)
    }
}
