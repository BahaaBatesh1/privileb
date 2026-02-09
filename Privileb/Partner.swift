//
//  Partner.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/11/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class Partner {
    var partner_name : String!
    var partner_logo : String!
    var offers : [Partner_offer] = []
    
    init(result : [String : Any]) {
       
        if let partner_name = result["partner_name"] as? String {
            self.partner_name = partner_name
        }else{
            self.partner_name = ""
        }
        
        if let partner_logo = result["partner_logo"] as? String{
            self.partner_logo = partner_logo
        }else{
            self.partner_logo = ""
        }
        
        if let offerss = result["offers"] as? [[String:Any]]{
            for offer in offerss {
                self.offers.append(Partner_offer(result: offer))
            }
        }else {
            self.offers = []
        }
        
        

    }
    



}
//
//"partner_logo": "http://privileb.com/admin_portal/images/retailers/17a3ec99bc4d50713488626f8cb97ce4.jpg",
//"partner_name": "Noha Moawad Beauty Institute",
//"offers":
