//
//  ChatViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/23/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage
import ChameleonFramework

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var messagesArray = [Messages]()
    var users = [User]()
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageBtnOutlet: UIButton!
    @IBOutlet weak var enterMessageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        chatTableView.addGestureRecognizer(tapGesture)
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        enterMessageTextField.delegate = self
        chatTableView.register(UINib(nibName: "Messages", bundle: nil), forCellReuseIdentifier: "CustomMessagesCell")
        configuretableView()
        retriveMessage()
        chatTableView.separatorStyle = .none
    }
    
    @objc func tableViewTapped() {
        enterMessageTextField.endEditing(true)
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        sendMessageBtnOutlet.isEnabled = false
        enterMessageTextField.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let dict = ["Sender": User.userSharefReference.email,"MessageBody":enterMessageTextField.text!]
        
        messageDB.childByAutoId().setValue(dict){ (error, reference) in
            
            if error != nil {
                
                print (error)
                
            } else {
                
                print ("Message Saved Successfully")
                self.enterMessageTextField.isEnabled = true
                self.sendMessageBtnOutlet.isEnabled = true
                self.enterMessageTextField.text = ""
            }
        }
    }
    
    func retriveMessage (){
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Messages()
            message.messageBody = text
            message.sender = sender
            
            self.messagesArray.append(message)
            self.configuretableView()
            self.chatTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessagesCell", for: indexPath) as! MessagesCell
        cell.messagebody.text = messagesArray[indexPath.row].messageBody
        cell.userName.text = messagesArray[indexPath.row].sender
        
        if let url = URL(string: users[indexPath.row].imageUrl){
            cell.avatarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        if cell.userName.text == User.userSharefReference.email {
                
                //Set background to blue if message is from logged in user.
                cell.avatarImage.backgroundColor = UIColor.flatMint()
                cell.messageBackgroundView.backgroundColor = UIColor.flatSkyBlue()
                
            } else {
                
                //Set background to grey if message is from another user.
                cell.avatarImage.backgroundColor = UIColor.flatWatermelon()
                cell.messageBackgroundView.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    func configuretableView () {
        
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 120.0
    }
    
       //MARK: - TextField Delegate Methods
     
       // Text Field Did Begin Editing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.bottomViewHeightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    // Text Field Did End Editing
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.bottomViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
            }
        }
    }
