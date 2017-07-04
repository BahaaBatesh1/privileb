//
//  branch.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/27/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation

class branch {
    var id : Int!
    var name :String!
    var latitude : Double!
    var longtude : Double!
    
    init(result : [String : Any]){
        if let id = result["id"] as? Int{
            self.id = id
        }
        else{
            self.id = 0
        }
        
        if let name = result["name"] as? String{
            self.name = name
        }
        else{
            self.name = ""
        }
        if let latitude = Double((result["latitude"] as? String)!){
            self.latitude = latitude
        }
        else{
            self.latitude = 0.0
        }

        if let longtude = Double((result["longitude"] as? String)!){
            self.longtude = longtude
        }
        else{
            self.longtude = 0.0
        }

        
    }

}
//
//"id": "45",
//"name": "Sushi Lab Independance Street",
//"latitude": "33.8869",
//"longitude": "35.5186"
