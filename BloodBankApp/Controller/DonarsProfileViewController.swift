//
//  DonarsProfileViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import SDWebImage

class DonarsProfileViewController: UIViewController {
    
    @IBOutlet weak var donarsImage: UIImageView!
    @IBOutlet weak var donarFirstName: UITextField!
    @IBOutlet weak var donarLastName: UITextField!
    @IBOutlet weak var donarPhoneNumber: UITextField!
    @IBOutlet weak var donarEmail: UITextField!
    @IBOutlet weak var donarBloodGroup: UITextField!
    @IBOutlet weak var donarDOB: UITextField!
    @IBOutlet weak var viewDiseaseBtnOut: UIButton!
    
    var donar:User!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        donarsImage.roundedImage()
        setUpDonarProfile()
        setUpElements()
        fieldsStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpDonarProfile() {
        
        self.donarFirstName.text = donar.firstName
        self.donarLastName.text = donar.lastName
        self.donarBloodGroup.text = donar.bloodGroup
        self.donarEmail.text = donar.email
        self.donarDOB.text = donar.dateOfBirth
        self.donarPhoneNumber.text = donar.phoneNumber
        if let url = URL(string: donar.imageUrl){
            self.donarsImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                
            }
        }
    }
    
    @IBAction func viewDiseaseBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "ViewDisease", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDisease" {
            let destination = segue.destination as! ViewDiseaseViewController
            destination.user = donar
        }
    }
    
    func fieldsStatus () {
        donarFirstName.isEnabled = false
        donarLastName.isEnabled = false
        donarPhoneNumber.isEnabled = false
        donarEmail.isEnabled = false
        donarBloodGroup.isEnabled = false
        donarDOB.isEnabled = false
    }
    
    func setUpElements () {
        
        Utilities.styleFilledButton(viewDiseaseBtnOut)
        Utilities.styleTextField(donarFirstName)
        Utilities.styleTextField(donarLastName)
        Utilities.styleTextField(donarPhoneNumber)
        Utilities.styleTextField(donarEmail)
        Utilities.styleTextField(donarBloodGroup)
        Utilities.styleTextField(donarDOB)
    }
}
