//
//  region.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class region {
    var region_id : Int!
    var name : String!
    
    init(result :[String: Any]) {
        
        if let region_id = Int((result["region_id"] as? String)!){
            self.region_id = region_id
        }else{
            self.region_id = 0
        }
        
        if let name = result["name"] as? String{
            self.name = name
        }else{
            self.name = ""
        }
        
       
        
    }


}
//
//"region_id": "27",
//"name": "Bcharre"
