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
        // tableView.deselectRow(at: indexPath, animated: true)
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
            //print (selectedDisease)
        }
    }
    
    @IBAction func saveDiseases(_ sender: Any) {
        
        //        Disease.diseasesSharedReference = userDisease
        //            ServerCommunication.sharedDelegate.uploadUserDiseases(diseaseArray: selectedDisease.getDiseasesDict()) { (status, message) in
        //            <#code#>
        //        }
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
}

