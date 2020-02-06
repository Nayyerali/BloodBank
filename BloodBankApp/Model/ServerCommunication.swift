//
//  ServerCommunication.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

public class ServerCommunication{
    
    var firebaseFirestore:Firestore!
    var firebaseStorage:Storage!
    
    static var sharedDelegate = ServerCommunication()
    
    private init() {
        firebaseFirestore = Firestore.firestore()
        firebaseStorage = Storage.storage()
    }
    
    func uploadUserData(userData:[String:Any],completion:@escaping(_ status:Bool,_ message:String)->Void){
        let userId = userData["UserId"] as! String
        firebaseFirestore.collection("Users").document(userId).setData(userData) { (error) in
            if error == nil{
                completion(true,"User data uploaded")
            }else{
                completion(false,error!.localizedDescription)
            }
        }
    }
    
    func uploadUserDiseases (diseaseArray:[String:String], completion:@escaping(_ status:Bool, _ message:String) -> Void) {
        
        let userId = diseaseArray["UserID"] as! String
        
        firebaseFirestore.collection("Diseases").document().setData(diseaseArray) { (error) in
            if error == nil {
                completion(true, "User Diseases Uploaded")
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    func uploadImage(image:UIImage,userId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
        // if status is true then downloadurl will be in response
        
        
        // Data in memory
        guard let data = image.jpegData(compressionQuality: 0.5) else{
            completion(false,"Unable to get data from image")
            return
        }
        
        // Create a reference to the file you want to upload
        let riversRef = firebaseStorage.reference().child("images/\(userId).jpg")
        // Upload the file to the path "images/rivers.jpg"
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                completion(false,error!.localizedDescription)
                return
            }
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completion(false,error!.localizedDescription)
                    return
                }
                
                completion(true,downloadURL.absoluteString)
                
            }
        }
    }
    
    func fetchUserData(userId:String,completion:@escaping(_ status:Bool,_ message:String,_ user:User?)->Void){
        
        // downloading user data using initialized firebase keys as dictionary
        
        firebaseFirestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let snapshot = snapshot{
                // you get some data
                if let userDic = snapshot.data(){
                    let user = User(userDict: userDic)
                    completion(true,"Get user Data",user)
                }else{
                    completion(false,"Unable to get user data",nil)
                }
                
            }else{
                // you get an error
                completion(false,error!.localizedDescription,nil)
            }
        }
    }
    
    func fetchAllDonarsData (completion:@escaping(_ status:Bool, _ message:String, _ users:[User]?) -> Void) {
        firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
            if error == nil {
                // Success
                if let usersData = snapshot?.documents {
                    // Got Donars
                    var users:Array = [User]()
                    for matchingUser in usersData {
                        let usersDocuments = matchingUser.data()
                        let firstName = usersDocuments["First Name"] as! String
                        let bloodGroup = usersDocuments["BloodGroup"] as! String
                        let imageUrl = usersDocuments["ImageURL"] as! String
                        let userId = usersDocuments["UserId"] as! String
                        let lastName = usersDocuments["LastName"] as! String
                        let email = usersDocuments["Email"] as! String
                        let dateOfBirth = usersDocuments["DateOfBirth"] as! String
                        let phoneNumber = usersDocuments["PhoneNumber"] as! String
                        
                        let user = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, bloodGroup: bloodGroup, phoneNumber: phoneNumber, email: email, userId: userId, imageUrl: imageUrl)
                        users.append(user)
                    }
                    completion(true, "Get Donars", users)
                } else {
                    // Donars doc not found
                    completion(false, "Donars Data Not Found", nil)
                }
            } else {
                // faliure
                completion(false, error!.localizedDescription,nil)
            }
        }
    }
    
    func fetchMatchingDonarsData (completion:@escaping(_ status:Bool, _ message:String, _ users:[User]?) -> Void) {
        
        firebaseFirestore.collection("Users").getDocuments { (snapshot, error) in
            if error == nil {
                // Success
                
                if let usersData = snapshot?.documents {
                    // Got Donars
                    var users:Array = [User]()
                    for matchingUser in usersData {
                        let usersDocuments = matchingUser.data()
                        let userId = usersDocuments["UserId"] as! String
                        if userId == Auth.auth().currentUser?.uid{
                            
                        }else{
                            
                            let firstName = usersDocuments["First Name"] as! String
                            let bloodGroup = usersDocuments["BloodGroup"] as! String
                            let imageUrl = usersDocuments["ImageURL"] as! String
                            
                            let lastName = usersDocuments["LastName"] as! String
                            let email = usersDocuments["Email"] as! String
                            let dateOfBirth = usersDocuments["DateOfBirth"] as! String
                            let phoneNumber = usersDocuments["PhoneNumber"] as! String
                            
                            let user = User(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, bloodGroup: bloodGroup, phoneNumber: phoneNumber, email: email, userId: userId, imageUrl: imageUrl)
                            
                            if User.userSharefReference.bloodGroup == "A+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "A-"{
                                switch bloodGroup {
                                case "A-", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "B+"{
                                switch bloodGroup {
                                case "B+", "B-", "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "B-"{
                                switch bloodGroup {
                                case "B-", "O+":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "AB+"{
                                switch bloodGroup {
                                case "A+", "A-", "O+", "O-", "B+","B-","AB+","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "AB-"{
                                switch bloodGroup {
                                case "A-","O-","B-","AB-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "O+"{
                                switch bloodGroup {
                                case "O+", "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }else if User.userSharefReference.bloodGroup == "O-"{
                                switch bloodGroup {
                                case "O-":
                                    users.append(user)
                                default:
                                    break
                                }
                            }
                            users.append(user)
                        }
                    }
                    completion(true, "Get Donars", users)
                } else {
                    // Donars doc not found
                    completion(false, "Donars Data Not Found", nil)
                }
            } else {
                // faliure
                completion(false, error!.localizedDescription,nil)
            }
        }
    }
}
