//
//  ViewDiseaseViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 3/9/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class ViewDiseaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var disease = [String]()
    var isCurrentUserComing = false
    
    var user:User?
    
//    {
//        didSet {
//            navigationItem.title = ("\(user!.firstName)'s Disease")
//        }
//    }

    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var viewDiseaseTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDiseases()
        
        viewDiseaseTableView.delegate = self
        viewDiseaseTableView.dataSource = self
        if isCurrentUserComing == true {
            navigationItem.title = "My Diseases"
            addBtn.isEnabled = true
        } else {
            navigationItem.title = ("\(user!.firstName)'s Disease")
            addBtn.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDiseases()
    }

    func fetchDiseases () {
        ServerCommunication.sharedDelegate.fetchUserDiseases(userId:user!.userId) { (status, message, disease) in
            if status {
                self.disease = disease!
                print (disease)
                self.viewDiseaseTableView.reloadData()
            } else {
               // self.disease.removeAll()
                self.showAlert(controller: self, title: "Found Nil", message: "User Have Not Added Any Disease") { (Ok) in
                    self.navigationController?.popViewController(animated: true)
                }
               print ("Unable To Get Any Diseases")
                
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disease.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewDiseasesTableViewCell") as! ViewDiseaseTableViewCell
        
        if disease.isEmpty{
            self.showAlert(controller: self, title: "Found Nil", message: "User Have Not Added Any Disease") { (Ok) in
                self.navigationController?.popViewController(animated: true)
                return
            }
        }else{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "viewDiseasesTableViewCell") as! ViewDiseaseTableViewCell
            cell.disease.text = disease[indexPath.row]
           
        }
         return cell
        
        
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

