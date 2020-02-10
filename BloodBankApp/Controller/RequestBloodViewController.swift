//
//  RequestBloodViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/8/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import SDWebImage

protocol addBloodRequestProtocol {
    
    func addBloodRequests(bloodRequest:BloodRequest)
}

class RequestBloodViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bloodRequestsTableView: UITableView!
    
    var bloodGroupArray:Array = [BloodRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bloodRequestsTableView.dataSource = self
        bloodRequestsTableView.delegate = self
        fetchAllBLoodRequests()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllBLoodRequests()
    }
    
    func fetchAllBLoodRequests() {
        ServerCommunication.sharedDelegate.fetchAllBloodRequests { (status, message, bloodGroups) in
            if status {
                // Success
                self.bloodGroupArray.removeAll()
                self.bloodGroupArray = bloodGroups!
                self.bloodRequestsTableView.reloadData()
            } else {
                // Faliure
                print ("Could Not Find Requests ")
            }
        }
    }
    
    func addNewRequest(bloodRequest:BloodRequest){
        self.bloodGroupArray.append(bloodRequest)
        self.bloodRequestsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloodGroupArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredBloodTableViewCell") as! RequestBloodTableViewCell
        cell.requiredBlood.text = bloodGroupArray[indexPath.row].bloodGroup
        cell.userName.text = bloodGroupArray[indexPath.row].firstName
        if let ImageUrl = URL(string: bloodGroupArray[indexPath.row].imageUrl) {
            cell.userImage.sd_setImage(with: ImageUrl, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                }
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             
             self.showAlert(controller: self, title: "Delete Blood Request", message: "Do you really want to delete this Request?", actiontitle: "Delete") { (isDelete) in
                 if isDelete{
                     ServerCommunication.sharedDelegate.deleteBloodRequest(id: self.bloodGroupArray[indexPath.row].id) { (status, message) in
                         if status{
                             self.showAlert(controller: self, title: "Success", message: message) { (ok) in
                                 self.bloodGroupArray.remove(at: indexPath.row)
                                 self.bloodRequestsTableView.reloadData()
                             }
                         }else{
                             self.showAlert(controller: self, title: "Faliur", message: message) { (ok) in
                                 
                             }
                         }
                     }
                 }
             }
         }
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
