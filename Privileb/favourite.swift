//
//  favourite.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/29/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class favourite {
    
    var favorite_id : String!
    var offer_id : String!
    var offer_name : String!
    var frequency : String!
    var issue_date : String!
    var expiry_date : String!
    var offer_image : String!
    var original_price : String!
    var retailer_name : String!

    init(result : [String : Any]){
        if let favorite_id = result["favorite_id"] as? String{
            self.favorite_id = favorite_id
        }
        else{
            self.favorite_id = ""
        }
        
        if let offer_id = result["offer_id"] as? String{
            self.offer_id = offer_id
        }
        else{
            self.offer_id = ""
        }
        if let offer_name = result["offer_name"] as? String{
            self.offer_name = offer_name
        }
        else{
            self.offer_name = ""
        }
        
        if let frequency = result["frequency"] as? String{
            self.frequency = frequency
        }
        else{
            self.frequency = ""
        }
        
        if let issue_date = result["issue_date"] as? String{
            self.issue_date = issue_date
        }
        else{
            self.issue_date = ""
        }
        if let expiry_date = result["expiry_date"] as? String{
            self.expiry_date = expiry_date
        }
        else{
            self.expiry_date = ""
        }
        
        if let offer_image = result["offer_image"] as? String{
            self.offer_image = offer_image
        }
        else{
            self.offer_image = ""
        }
        
        if let original_price = result["original_price"] as? String{
            self.original_price = original_price
        }
        else{
            self.original_price = ""
        }
        
        if let retailer_name = result["retailer_name"] as? String{
            self.retailer_name = retailer_name
        }
        else{
            self.retailer_name = ""
        }
        
       
    }
    
}
//
//{
//    "favorite_id": "151",
//    "offer_id": "253",
//    "offer_name": "20% Discount",
//    "frequency": "Unlimited",
//    "issue_date": "2017-06-15",
//    "expiry_date": "2018-12-15",
//    "offer_image": "http://privileb.com/admin_portal/images/offers/594cfff244200.png",
//    "original_price": "0",
//    "retailer_name": "Fiordelli Donna"
//}
