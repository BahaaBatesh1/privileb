//
//  district.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class district {

    var district_id : Int!
    var name : String!
    
    
    init(result :[String: Any]) {
        
        if let district_id = Int((result["district_id"] as? String)!){
            self.district_id = district_id
        }else{
            self.district_id = 0
        }
        
        if let name = result["name"] as? String{
            self.name = name
        }else{
            self.name = ""
        }
        
        
        
    }

}

////// 
//{
//    "district_id": "5",
//    "name": "Akkar"
//},
