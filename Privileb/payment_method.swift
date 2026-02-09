//
//  payment_method.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation

class payment_method {
    
    var method_id : Int!
    var name : String!
    
    
    init(result : [String : Any]) {
        if let method_id = Int((result["method_id"] as? String)!){
            self.method_id = method_id
        }
        else {
            self.method_id = 0
        }
        
        if let name = (result["name"] as? String){
            self.name = name
        }
        else {
            self.name = ""
        }

    }


}

//method_id":"1","name":"COD"
