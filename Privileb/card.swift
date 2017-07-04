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
    var image_front : String!
    var image_back : String!

    init(result :[String: Any]) {
        
        if let id = Int((result["id"] as? String)!){
            self.id = id
        }else{
            self.id = 0
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
        
        if let image_front = result["image_front"] as? String{
            self.image_front = image_front
        }else{
            self.image_front = ""
        }
        
        if let image_back = result["image_back"] as? String{
            self.image_back = image_back
        }else{
            self.image_back = ""
        }
        
        
        
    }




}
//
//"data": {
//    "id": "3",
//    "serial_number": "111111111",
//    "expiry_date": "2018/05",
//    "image_front": "http://privileb.com/admin_portal/images/cardfront/83e04f5eb626a506e7e2dabeaf654b0d.png",
//    "image_back": "http://privileb.com/admin_portal/images/cardback/9efa05cf2fee89f462b433fe6e3a8649.png"
//}
//}
