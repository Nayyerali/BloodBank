//
//  DiseasesViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/2/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit

class DiseasesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var userDiseases = [Disease]()
    var searchDiseases = [Disease]()
    var selectedDisease = [Disease]()
    var searchingDieases = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var diseaseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedDisease.removeAll()
        downloadJson ()
        
        self.diseaseTableView.isEditing = true
        self.diseaseTableView.allowsMultipleSelectionDuringEditing = true
        diseaseTableView.dataSource = self
        diseaseTableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchingDieases {
            return searchDiseases.count
        } else {
            return userDiseases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseTableViewCell") as! DiceaseTableViewCell
        
        if searchingDieases {
            cell.diseasesTextField.text = searchDiseases[indexPath.row].disease
            
        } else {
            cell.diseasesTextField.text = userDiseases[indexPath.row].disease
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    func selectDeselectCell(tableView: UITableView, indexPath: IndexPath){
        self.selectedDisease.removeAll()
        if let selectionArray = tableView.indexPathsForSelectedRows{
            for indexOfRow in selectionArray {
                selectedDisease.append(userDiseases[indexPath.row])
            }
        }
    }
    
    
    //
    //    var result = [selectedDisease].reduce([[String: String]](), { (previous, current) -> [[String: String]] in
    //        let type = previous.count == 0 ? "A" : "B"
    //        let dictForCurrent = [
    //            "name": current,
    //            "type": type
    //        ]
    //        return previous + [dictForCurrent]
    //    })
    
    
    //let scoreboard = self.selectedDisease.reduce(into: [:]) { $0[$1] = 0 }
    
    //    func arrayToDict() {
    //
    //    let scoreboard: [String: Int] = selectedDisease.reduce(into: [:], { result, next in
    //        result[next] = 0
    //            }
    //        )
    //    }
    //    let scoreboard = selectedDisease.reduce(into: [String: Int]()) { $0[$1] = 0 }
    
    // unable to store Diseases because its type of array and i am currenlty unable to resolve this issue
    
    
    
    
    
    @IBAction func saveDiseases(_ sender: Any) {
        
        //  abc()
        
        var dictDiseaseArray: [Disease: Int] = selectedDisease.reduce(into: [:], {result, next in
            result[next] = 0
            }
        )
        
        ServerCommunication.sharedDelegate.uploadUserDiseases(addedDisease: dictDiseaseArray, imageUrl: User.userSharefReference.imageUrl, name: User.userSharefReference.firstName) { (status, message) in
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
    
    // this functionality is not used
    
    //    func forSelectingAllValuesInTableView (_ sender: Any) {
    //        self.selectedDisease.removeAll()
    //        if sender.isSelected{
    //            for row in 0..<userDiseases.count {
    //                self.diseaseTableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
    //            }
    //            sender.isSelected = false
    //            sender.setImage(UIImage(named: "Select.png"), for: .normal)
    //            selectedDisease = userDiseases
    //        } else {
    //            for row in 0..<userDiseases.count{
    //                self.diseaseTableView.deselectRow(at: IndexPath(row: row, section: 0), animated: false)
    //            }
    //            sender.isSelected = true
    //            sender.setImage(UIImage(named: "deSelect.png"), for: .normal)
    //            self.selectedDisease.removeAll()
    //        }
    //    }
    
    func downloadJson () {
        
        let url = URL(string: "https://raw.githubusercontent.com/Shivanshu-Gupta/web-scrapers/master/medical_ner/medicinenet-diseases.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    let abc = try JSONDecoder().decode([Disease].self, from: data!)
                    print("Json fetched Succesfully")
                    for diseses in abc{
                        
                        self.userDiseases.append(diseses)
                    }
                    DispatchQueue.main.async {
                        
                        self.diseaseTableView.reloadData()
                    }
                } catch {
                    print ("Data Not Found")
                }
            }
        }.resume()
    }
    
    // User input text in search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // alphabetically search Disease
        searchDiseases = userDiseases
        searchDiseases = userDiseases.filter({$0.disease.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searchingDieases = true
        diseaseTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchingDieases = false
        searchBar.text = ""
        diseaseTableView.reloadData()
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

