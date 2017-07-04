//
//  sub_category.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/27/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class sub_category {
    var sub_category_id : Int!
    var name : String!
    
    init(result : [String : Any]){
        if let sub_category_id = result["sub_category_id"] as? Int{
            self.sub_category_id = sub_category_id
        }
        else{
            self.sub_category_id = 0
        }
    
        if let name = result["name"] as? String{
            self.name = name
        }
        else{
           self.name = ""
        }
        
        if let name = result["category_name"] as? String{
            self.name = name
        }
        else{
            self.name = ""
        }

    }
}
//
//"sub_category_id": "30",
//"name": "Armenian Cuisine"
