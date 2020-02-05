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
        //cell.donarImage.image = user[indexPath.row].imageUrl
        if let url = URL(string: User.userSharefReference.imageUrl){
            cell.donarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
}
