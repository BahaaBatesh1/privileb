//
//  postResponse.swift
//  Privileb
//
//  Created by SSS on 6/30/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class postResponse {
    var status : Int!
    var message : String!
    
     init(result :[String: Any]) {
        if let message = result["message"] as? String{
            self.message = message
        }else{
            self.message = ""
        }
    
        if let status = result["status_code"] as? Int{
            self.status = status
        }else{
            self.status = 0000
        }
    }
}
