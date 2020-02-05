//
//  User.swift
//  BloodBankApp
//
//  Created by Nayyer Ali on 1/14/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct User:Comparable {
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.bloodGroup < rhs.bloodGroup
    }
    
    static var userSharefReference:User!
    
        // Created STruct for uploading user data
    
    var firstName:String
    var lastName:String
    var dateOfBirth:String
    var bloodGroup:String
    var phoneNumber:String
    var email:String
//    var password:String
//    var confirmPassword:String
    var userId:String
    var imageUrl:String
    
        // Creating firebase keys
    
    enum FirebaseKeys:String {
        case FirstName = "First Name"
        case LastName = "LastName"
        case ImageURL = "ImageURL"
        case DateOfBirth = "DateOfBirth"
        case BloodGroup = "BloodGroup"
        case PhoneNumber = "PhoneNumber"
        case Email = "Email"
//        case Password = "Password"
//        case ConfirmPassword = "ConfirmPassword"
        case UserID = "UserId"
    }
    
        // initalizing firebase keys to download data
    
    init (userDict:[String:Any]) {
        self.firstName = userDict[FirebaseKeys.FirstName.rawValue] as! String
        self.lastName = userDict[FirebaseKeys.LastName.rawValue] as! String
        self.dateOfBirth = userDict[FirebaseKeys.DateOfBirth.rawValue] as! String
        self.bloodGroup = userDict[FirebaseKeys.BloodGroup.rawValue] as! String
        self.phoneNumber = userDict[FirebaseKeys.PhoneNumber.rawValue] as! String
        self.email = userDict[FirebaseKeys.Email.rawValue] as! String
//        self.password = userDict[FirebaseKeys.Password.rawValue] as! String
//        self.confirmPassword = userDict[FirebaseKeys.ConfirmPassword.rawValue] as! String
        self.userId = userDict[FirebaseKeys.UserID.rawValue] as! String
        self.imageUrl = userDict[FirebaseKeys.ImageURL.rawValue] as! String
    }
    
        // initialized struct propertes to use for uploading data
    
    init (firstName:String,lastName:String,dateOfBirth:String,bloodGroup:String,phoneNumber:String,email:String,userId:String,imageUrl:String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.bloodGroup = bloodGroup
        self.phoneNumber = phoneNumber
        self.email = email
//        self.password = password
//        self.confirmPassword = confirmPassword
        self.userId = userId
        self.imageUrl = imageUrl
        
    }
    
    // creating dictionary for uploading user data as dictionary
    
    // Firebase.fullname.raw value is user keys name n firebase and self.full name is coming from textfields
    
    
    func getUserDict()->[String:Any] {
    return [
        FirebaseKeys.FirstName.rawValue:self.firstName,
        FirebaseKeys.LastName.rawValue:self.lastName,
        FirebaseKeys.DateOfBirth.rawValue:self.dateOfBirth,
        FirebaseKeys.BloodGroup.rawValue:self.bloodGroup,
        FirebaseKeys.PhoneNumber.rawValue:self.phoneNumber,
        FirebaseKeys.Email.rawValue:self.email,
//        FirebaseKeys.Password.rawValue:self.password,
//        FirebaseKeys.ConfirmPassword.rawValue:self.confirmPassword,
        FirebaseKeys.UserID.rawValue:self.userId,
        FirebaseKeys.ImageURL.rawValue:self.imageUrl
        ]
    }
}
