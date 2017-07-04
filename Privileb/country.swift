//
//  country.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class country{

    var country_id : Int!
    var country_name : String!
    var country_code : String!
    var currency : String!



    init(result :[String: Any]) {
        
        if let country_id = Int((result["country_id"] as? String)!){
            self.country_id = country_id
        }else{
            self.country_id = 0
        }
        
        if let country_name = result["country_name"] as? String{
            self.country_name = country_name
        }else{
            self.country_name = ""
        }
        
        if let country_code = result["country_code"] as? String{
            self.country_code = country_code
        }else{
            self.country_code = ""
        }
        
        if let currency = result["currency"] as? String{
            self.currency = currency
        }else{
            self.currency = ""
        }

        
    }


}

//// country_id":"1","country_name":"Lebanon","country_code":"lb","currency":"lbp"}
