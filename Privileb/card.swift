//
//  card.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation

class card {
    var id : Int!
    var serial_number : String!
    var expiry_date : String!
    var cardHolderName: String!
    var userId:Int
    init(result :[String: Any]) {
        
        if let id = Int((result["id"] as? String)!){
            self.id = id
        }else{
            self.id = 0
        }
        
        if let uid = Int((result["user_id"] as? String)!){
            self.userId = uid
        }else{
            self.userId = 0
        }
        
        if let holder = result["cardholder_name"] as? String{
            self.cardHolderName = holder
        }else{
            self.cardHolderName = ""
        }
        
        if let serial_number = result["serial_number"] as? String{
            self.serial_number = serial_number
        }else{
            self.serial_number = ""
        }
        
        if let expiry_date = result["expiry_date"] as? String{
            self.expiry_date = expiry_date
        }else{
            self.expiry_date = ""
        }

        
    }




}
//["status_code": 1, "data": {
//    "cardholder_name" = "Johnny Chawa";
//    "expiry_date" = "2018/07";
//    id = 510;
//    "serial_number" = 123456;
//    "user_id" = 265;
//    }, "message": Card get successfully.]
