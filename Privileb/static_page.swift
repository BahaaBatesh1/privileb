//
//  static_page.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/27/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class static_page{
    var id : Int!
    var name : String!
    var description : String!
    var image : String!
    var description_ar : String!

    
    init(result : [String : Any]){
        
        if let id = Int((result["id"] as? String)!){
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
        if let description = result["description"] as? String{
            self.description = description
        }
        else{
            self.description = ""
        }

        if let description = result["description_ar"] as? String{
            self.description_ar = description
        }
        else{
            self.description_ar = ""
        }
        
        if let image = result["image"] as? String{
            self.image = image
        }
        else{
            self.image = ""
        }

    }
    
}
//
//"id": "1",
//"name": "About Us",
//"description": "About Privileb Card\r\nThe Privileb privilege card entitles cardholders to enjoy exclusive offers and discounts at a large network of partners in Lebanon and abroad.\r\nFrom dining to activities, spas, resorts, hotels, travel and leisures to products, Privileb is your passport to a rewarding experience.\r\nPrivileb partners and offers are prestigious and includes only the best businesses in town.\r\nOffers and discounts are carefully curated to provide you with the best experience at lower cost, and by the best experience we do not mean the buy one get one free!\r\nWe are committed to offering our cardholders various offers and discounts to fit each and everyoneâs taste and interest. Privileb is simply made for you!\r\nPrivileb is all about innovation, our mobile application is not only a listing directory for our offers but a complete tool to make your experience seamless.\r\nDo you hate carrying another plastic card in your wallet, here comes Privileb Mobile App.  \r\nOur mobile application is a full substitute to the card with additional features:  \r\n\r\nCheck offers and deals around you wherever you are.  \r\nSearch through the offers and details.\r\nCheck the history of your previous benefits through Privileb. \r\nGet instant push updates when a great offer is around.\r\nScan a QR code to benefit from the offer with no need to show the card.\r\n\r\nOur target card holders are a selection of activity and outing enthusiasts that will drive traffic to all businesses listed with Privileb.\r\nCard Holders will include:\r\n\r\nMillennials \r\nAdherents to professional unions and orders (Engineers, medical doctors, lawyers etcâ¦)\r\nMid and High income individuals.\r\n",
//"image": "PAGE_IMAGE_DIRd6e90bf4db47c2ff28701e3409fe594d.jpg"
//}
