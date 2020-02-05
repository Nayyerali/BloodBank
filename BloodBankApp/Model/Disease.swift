//
//  Disease.swift
//  TableViewANdJsonParsing
//
//  Created by Nayyer Ali on 1/31/20.
//  Copyright © 2020 Nayyer Ali. All rights reserved.
//

import Foundation

struct Disease: Decodable{
    var disease: String
    var userId:String
    
    static var diseasesSharedReference:Disease!

    // initalizing firebase keys to download data
    
    init (diseaseArray:[String:Any]) {
        self.disease = diseaseArray[FirebaseKeys.Disease.rawValue] as! String
        self.userId = diseaseArray[FirebaseKeys.UserId.rawValue] as! String
    }

    // initialized struct propertes to use for uploading data
    
    init(disease:String,userId:String) {
        self.disease = disease
        self.userId = userId
    }
    
    // creating dictionary for uploading user Disease as dictionary
    
    // Firebase.disease.raw value is user keys name n firebase and self.disease  is coming from textfields
    
    func getDiseasesDict()->[String:Any] {
    return [
        FirebaseKeys.Disease.rawValue:self.disease,
        FirebaseKeys.UserId.rawValue:self.userId]
    }
    
    // Creating firebase keys
    
    enum FirebaseKeys:String {
        case Disease = "Disease"
        case UserId = "UserID"
    }
}
