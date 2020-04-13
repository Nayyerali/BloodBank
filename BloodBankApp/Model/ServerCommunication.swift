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
import FirebaseDatabase

public class ServerCommunication{
    
    var firebaseFirestore:Firestore!
    var firebaseStorage:Storage!
    var firebaseDatabase:Database!
    
    
    static var sharedDelegate = ServerCommunication()
    
    private init() {
        firebaseFirestore = Firestore.firestore()
        firebaseStorage = Storage.storage()
        firebaseDatabase = Database.database()
    }
    
    func requestdBlood(bloodGroup:String,imageUrl:String,name:String,completion:@escaping(_ status:Bool,_ message:String)->Void){
        let reference = firebaseFirestore.collection("BloodRequest").document().setData(["BloodGroup":bloodGroup,"Name":name,"ImageUrl":imageUrl,"Date":FieldValue.serverTimestamp(),"Id":Auth.auth().currentUser?.uid,"UserId":User.userSharefReference.userId]) { (error) in
            if error == nil{
                // Success
                completion(true,"Blood Request is added")
            }else{
                // Fail
                completion(false,(error?.localizedDescription)!)
            }
        }
    }

    func uploadUserDiseases (addedDisease:[String],completion:@escaping(_ status:Bool,_ message:String)->Void){
        
        //        let diseaseCollection = firebaseFirestore.collection("Users").document(User.userSharefReference.userId).collection("User Disease").document(User.userSharefReference.userId).setData(["Disease":addedDisease]) { (error) in
//
//        let reference = firebaseFirestore.collection("Users").document(User.userSharefReference.userId).updateData(["Disease":addedDisease]) { (error) in
//
//            if error == nil {
//                // Success
//                completion(true, "Selected Diseases Are Added Successfully")
//            } else {
//                // Failure
//                completion(false, (error!.localizedDescription))
//            }
//        }
        
        let reference = firebaseFirestore.collection("Diseases").document(User.userSharefReference.userId).setData(["Disease":addedDisease]) { (error) in

            if error == nil {
                // Success
                completion(true, "Selected Diseases Are Added Successfully")
            } else {
                // Failure
                completion(false, (error!.localizedDescription))
            }
        }
    }
    
    func fetchUserDiseases (userId:String,completion:@escaping(_ status:Bool,_ message:String,_ arrayOfDisease:[String]?)->Void) {
        firebaseFirestore!.collection("Diseases").document(userId).getDocument { (snapshot, error) in
            
           // if error == nil {
            if let snapshots = snapshot {
                if let diseaseSnapshot = snapshots.data(){
                let diseases = diseaseSnapshot["Disease"] as! [String]
                completion(true, "Got User Disease",diseases)
            } else {
                completion(false, "Could Not Get User Disease",nil)
            }
        }else{
            // you get an error
                completion(false,error!.localizedDescription,nil)
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
    
    func fetchAllBloodRequests(completion:@escaping(_ status:Bool, _ message:String,_ tasks:[BloodRequest]?)->Void){
        
        firebaseFirestore.collection("BloodRequest").getDocuments { (snapshot, error) in
            if error == nil {
                // Blood Request Are Fetched Succesfully
                if let requestDoc = snapshot?.documents{
                    // Got Requests Data
                    var requests:Array = [BloodRequest]()
                    for bloodRequest in requestDoc {
                        let requestData = bloodRequest.data()
                        let name = requestData["Name"] as! String
                        //let date = requestData["Date"] as! Timestamp
                        let requiredBloodGroup = requestData["BloodGroup"] as! String
                        let id = requestData["Id"] as! String
                        let image = requestData["ImageUrl"] as! String
                        
                        let newBloodrequest = BloodRequest(firstName: name, bloodGroup: requiredBloodGroup, userId: User.userSharefReference.userId, imageUrl: image, id: id)
                        requests.append(newBloodrequest)
                    }
                    completion(true,"Got Requests tasks",requests)
                    
                }else{
                    // request doc not found
                    completion(false, "Request data not found",nil)
                }
            }else{
                // failure
                completion(false,error!.localizedDescription,nil)
            }
        }
    }
    
    func deleteBloodRequest(id:String,completion:@escaping(_ status:Bool, _ message:String)->Void){
        
        
        firebaseFirestore.collection("BloodRequest").document(id).delete { (error) in
            if error == nil{
                completion(true,"Blood Request is deleted")
            }else{
                completion(false,error!.localizedDescription)
            }
        }
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
                            //let usersIDTest = usersDocuments["UserId"] as! String
                            
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
                            //users.append(user)
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
