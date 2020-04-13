//
//  MatchingDonarsViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class AllDonarsViewController: UIViewController {
    
    var user = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllDOnarsData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.allowsSelection = true
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func fetchAllDOnarsData() {
        
        ServerCommunication.sharedDelegate.fetchAllDonarsData { (status, message, users) in
            if status {
                // Success
                self.user = users!
                self.tableView.reloadData()
            } else {
                // faliure
                print ("Could not find Data")
            }
        }
    }
}

extension AllDonarsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "donarsCell") as! DonarsTableViewCell
        cell.donarUserName.text = user[indexPath.row].firstName
        cell.donarBloodGroup.text = user[indexPath.row].bloodGroup
        //  cell.donarImage.image = user[indexPath.row].imageUrl
        if let url = URL(string: (user[indexPath.row].imageUrl)){
            cell.donarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.allowsSelection = false
        let userID = self.user[indexPath.row].userId
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let donarProfileController = storyBoard.instantiateViewController(identifier: "DonarsProfileViewController") as! DonarsProfileViewController
        ServerCommunication.sharedDelegate.fetchUserData(userId: userID) { (status, message, user) in
            if status{
                donarProfileController.donar = user
                self.navigationController!.pushViewController(donarProfileController, animated: true)
                
            }else{
            }
        }
    }
}
