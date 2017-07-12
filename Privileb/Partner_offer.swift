//
//  Partner_offer.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/10/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class Partner_offer {

    var id : String!
    var Name : String!
    var description:String!
    init(result :[String: Any]) {
        
        if let id = result["id"] as? String {
            self.id = id
        }else{
            self.id = ""
        }
        
        if let Name = result["name"] as? String{
            self.Name = Name
        }else{
            self.Name = ""
        }
        
        if let des = result["offer_description"] as? String{
            self.description = des
        }else{
            self.description = ""
        }
        
        
    }
    



}
