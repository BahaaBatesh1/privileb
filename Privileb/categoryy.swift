//
//  categoryy.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation


class categoryy{
    
    var category_id : Int!
    
    var name : String!
    
    var image : String!
    
    var icon_active : String!
    
    var icon_inactive : String!

    init(result :[String: Any]) {
        if let category_id = Int((result["category_id"] as? String)!){
            self.category_id = category_id
        }else{
            self.category_id = 0
        }
        
        if let name = result["name"] as? String{
            self.name = name
        }else{
            self.name = ""
        }
        
        if let image = result["image"] as? String{
            self.image = image
        }else{
            self.image = ""
        }
        if let icon_active = result["icon_active"] as? String{
            self.icon_active = icon_active
        }else{
            self.icon_active = ""
        }

        if let icon_inactive = result["icon_inactive"] as? String{
            self.icon_inactive = icon_inactive
        }else{
            self.icon_inactive = ""
        }


    }





}
//
//"category_id": "2",
//"name": "Activities & Sporting Goods",
//"image": "http://privileb.com/admin_portal/images/categories/app_84a2d15774349168f26f789e487e7b74.jpg",
//"icon_active": "http://privileb.com/admin_portal/images/categories/icons/active_activities.png",
//"icon_inactive": "http://privileb.com/admin_portal/images/categories/icons/inactive_activities.png"
