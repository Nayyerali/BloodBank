//
//  ChatLogsViewController.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 2/24/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ChatLogsViewController:UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    
    let cellId = "cellId"
    var messages = [MessagesClass]()
    var userForImages = [User]()
    
    var users:User! {
        didSet {
            navigationItem.title = users.firstName
            observeMessages()
        }
    }
    
    @IBOutlet weak var bottomVIewForKeyboard: UIView!
    @IBOutlet weak var enterMessageField: UITextView!
    @IBOutlet weak var sendBtnOut: UIButton!
    @IBOutlet weak var chatLogsCollectionVIew: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        enterMessageField.isEditable = true
        enterMessageField.layer.borderWidth = 1
        enterMessageField.layer.borderColor = UIColor.black.cgColor
        chatLogsCollectionVIew?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        chatLogsCollectionVIew?.alwaysBounceVertical = true
        chatLogsCollectionVIew?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.addObservsers()
        self.addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toId = users?.userId else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = MessagesClass(dictionary: dictionary)
                
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.chatLogsCollectionVIew?.reloadData()
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func addObservsers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOpen(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardClosed), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardClosed(){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardOpen(notification:Notification){
        
        getKeyboardHeight(notification: notification)
        self.view.frame.origin.y = -getKeyboardHeight(notification: notification) + 25
    }
    
    func getKeyboardHeight(notification:Notification)->CGFloat{
        let info = notification.userInfo
        let keyboardFrame = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.cgRectValue.size.height
    }
    
    func addTapGesture(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(screenTaped))
        self.chatLogsCollectionVIew.addGestureRecognizer(tapGes)
        self.chatLogsCollectionVIew.isUserInteractionEnabled = true
    }
    
    @objc func screenTaped(){
        sendBtn(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        //lets modify the bubbleView's width somehow???
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        
        return cell
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: MessagesClass) {
        if let profileImageUrl = self.users?.imageUrl {
            
            if let url = URL(string: (profileImageUrl)){
                cell.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
                }
            }
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatLogsCollectionVIew?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    func fetchAllDOnarsData() {
        
        ServerCommunication.sharedDelegate.fetchAllDonarsData { (status, message, users) in
            if status {
                // Success
                self.userForImages = users!
                self.chatLogsCollectionVIew.reloadData()
            } else {
                // faliure
                print ("Could not find Data")
            }
        }
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        if enterMessageField.text == "" {
            return
        } else {
            
            let ref = Database.database().reference().child("Messages")
            let childRef = ref.childByAutoId()
            let toId = users.userId
            let fromId = Auth.auth().currentUser?.uid
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values = ["Message": enterMessageField.text!, "Timestamp": timeStamp, "FromID": fromId, "ToID":toId] as [String : Any]
            
            childRef.updateChildValues(values) { (error, ref) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                self.enterMessageField.text = nil
                
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!).child(toId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId!).child(messageId)
                recipientUserMessagesRef.setValue(1)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendBtn(self)
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
