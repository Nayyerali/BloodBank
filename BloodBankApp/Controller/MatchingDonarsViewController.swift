//
//  MatchingDonarsViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/24/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class MatchingDonarsViewController: UIViewController {
    
    var user = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchMatchingDonarsData()
        fetchUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    func fetchUserData () {
        if User.userSharefReference == nil {
            
            if let user = Auth.auth().currentUser{
                ServerCommunication.sharedDelegate.fetchUserData(userId: user.uid) { (status, message, user) in
                    print (user?.userId)
                    if status {
                        User.userSharefReference = user!
                        self.fetchMatchingDonarsData()
                    } else {
                        print("Could not find User Data")
                    }
                }
            }
        }
    }
    
    func fetchMatchingDonarsData () {
        ServerCommunication.sharedDelegate.fetchMatchingDonarsData{ (status, message, users) in
            
            if status {
                // Success
                func fetchUserData () {
                    if User.userSharefReference == nil {
                        if let user = Auth.auth().currentUser{
                            ServerCommunication.sharedDelegate.fetchUserData(userId: user.uid) { (status, message, user) in
                                if status {
                                    User.userSharefReference = user!
                                    self.fetchMatchingDonarsData()
                                } else {
                                    print("Could not find User Data")
                                }
                            }
                        }
                    }
                }
                
                self.user = users!
                self.tableView.reloadData()
            } else {
                // faliure
                print ("Could not find Data")
            }
        }
    }
}
extension MatchingDonarsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchingDonarsCell") as! MatchingDonarsTableViewCell
        cell.donarUserName.text = user[indexPath.row].firstName
        cell.donarBloodGroup.text = user[indexPath.row].bloodGroup
        if let url = URL(string: user[indexPath.row].imageUrl){
            cell.donarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        let profileController = storyboard!.instantiateViewController(identifier: "DonarProfileViewController") as! DonarsProfileViewController
        present(profileController, animated: true, completion: nil)
       
    }
}
