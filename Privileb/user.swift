//
//  user.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation


class user {


    
    var id : Int! = 0
    var fname : String! = ""
    var lname : String! = ""
    var email : String! = ""
    var address : String! = ""
    var password : String! = ""
    var card_id : Int! = 0
    var mobile_number : Int! = 0
    var birthdate : String! = ""
    var creation_date : String! = ""
    var gender : String! = ""
    var country_id : String! = ""
    var response : postResponse!
    var type:String! = ""
    
    //partner
    
    var is_active : String!
    var username : String!
    var radius : String!
    var longitude : String!
    var latitude : String!
    var region_id : String!
    var retailer_id : String!
    var name : String!
    var phone_number : String!

    
    
    init(result :[String: Any]) {
        
        self.response = postResponse(result: result)
        
        if self.response.status == 1 {
            if let data = result["data"] as? [String: Any]{
            
            if let id = Int((data["id"] as? String)!){
                self.id = id
            }else{
                self.id = 0
            }
            
            if let fname = data["fname"] as? String{
                self.fname = fname
            }else{
                self.fname = ""
            }
            
            if let lname = data["lname"] as? String{
                self.lname = lname
            }else{
                self.lname = ""
            }
            if let email = data["email"] as? String{
                self.email = email
            }else{
                self.email = ""
            }
            
            if let address = data["address"] as? String{
                self.address = address
            }else{
                self.address = ""
            }
            
            if let password = data["password"] as? String{
                self.password = password
            }else{
                self.password = ""
            }
            
            if let card_id = data["card_id"] as? Int{
                self.card_id = card_id
            }else{
                self.card_id = 0000
            }
            
            if let mobile_number = data["mobile_number"] as? Int{
                self.mobile_number = mobile_number
            }else{
                self.mobile_number = 0000
            }
            
            if let birthdate = data["birthdate"] as? String{
                self.birthdate = birthdate
            }else{
                self.birthdate = ""
            }
            
            if let creation_date = data["creation_date"] as? String{
                self.creation_date = creation_date
            }else{
                self.creation_date = ""
            }
            
            if let gender = data["gender"] as? String{
                self.gender = gender
            }else{
                self.gender = ""
            }
            
            if let country_id = data["country_id"] as? String{
                self.country_id = country_id
            }else{
                self.country_id = ""
            }
            
            
          
            
            if let latitude = data["latitude"] as? String{
                self.latitude = latitude
            }else{
                self.latitude = ""
            }
            
            if let region_id = data["region_id"] as? String{
                self.region_id = region_id
            }else{
                self.region_id = ""
            }
            
            if let retailer_id = data["retailer_id"] as? String{
                self.retailer_id = retailer_id
            }else{
                self.retailer_id = ""
            }
            
            if let name = data["name"] as? String{
                self.name = name
            }else{
                self.name = ""
            }
            
            if let phone_number = data["phone_number"] as? String{
                self.phone_number = phone_number
            }else{
                self.phone_number = ""
            }

            
        
        
        }
        
        if let typ = result["type"] as? String{
            self.type = typ
        }else{
            self.type = ""
            }
        }
    }
}
