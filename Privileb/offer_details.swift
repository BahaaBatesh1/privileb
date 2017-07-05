//
//  offer_details.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/29/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
class offer_details {
    
    var offer_id : String!
    var offer_name : String!

    var offer_description : String!
    var offer_summary : String!
    var issue_date : String!
    var expiry_date : String!
    var validity : String!
    var frequency : String!
    var original_price : String!
    var discount_price : String!
    var sub_categories : [sub_category] = []
    var branches : [branch] = []
    var retailer_name : String!
    var retailer_logo : String!
    var retailer_insta : String!
    var retailer_fb : String!
    var retailer_twitter : String!
    var retailer_website : String!
    var description : String!
    var currency : String!
    var url : String!
    var gallery : [String]?
    var gallery_cropped : [String]?
    
    var galleryImage : [UIImage] = []
    var gallery_croppedImage : [UIImage] = []
    
    var featured : String!
    var featured_cropped : String!

    
    
    init(result : [String : Any]){
        if let offer_id = result["offer_id"] as? String{
            self.offer_id = offer_id
        }
        else{
            self.offer_id = ""
        }
        
        if let offer_name = result["offer_name"] as? String{
            self.offer_name = offer_name
        }
        else{
            self.offer_name = ""
        }
        if let offer_description = String((result["offer_description"] as? String)!){
            self.offer_description = offer_description
        }
        else{
            self.offer_description = ""
        }
        
        if let offer_summary = String((result["offer_summary"] as? String)!){
            self.offer_summary = offer_summary
        }
        else{
            self.offer_summary = ""
        }
        if let issue_date = String((result["issue_date"] as? String)!){
            self.issue_date = issue_date
        }
        else{
            self.issue_date = ""
        }

        if let expiry_date = String((result["expiry_date"] as? String)!){
            self.expiry_date = expiry_date
        }
        else{
            self.expiry_date = ""
        }

        if let validity = String((result["validity"] as? String)!){
            self.validity = validity
        }
        else{
            self.validity = ""
        }

        if let frequency = String((result["frequency"] as? String)!){
            self.frequency = frequency
        }
        else{
            self.frequency = ""
        }

        if let original_price = String((result["original_price"] as? String)!){
            self.original_price = original_price
        }
        else{
            self.original_price = ""
        }

        if let discount_price = String((result["discount_price"] as? String)!){
            self.discount_price = discount_price
        }
        else{
            self.discount_price = ""
        }

        if let sub_categories = result["sub_category"] as? [[String:Any]]!{
            for sub in sub_categories {
                self.sub_categories.append(sub_category(result: sub))
            }
        }
        else{
            self.sub_categories = []
        }

        if let branches = result["branches"] as? [[String:Any]]!{
            for bran in branches {
                self.branches.append(branch(result: bran))
            }
        }else{
            self.branches = []
        }

        if let retailer_name = String((result["retailer_name"] as? String)!){
            self.retailer_name = retailer_name
        }
        else{
            self.retailer_name = ""
        }

        if let retailer_logo = String((result["retailer_logo"] as? String)!){
            self.retailer_logo = retailer_logo
        }
        else{
            self.retailer_logo = ""
        }

        if let retailer_insta = String((result["retailer_insta"] as? String)!){
            self.retailer_insta = retailer_insta
        }
        else{
            self.retailer_insta = ""
        }

        if let retailer_fb = String((result["retailer_fb"] as? String)!){
            self.retailer_fb = retailer_fb
        }
        else{
            self.retailer_fb = ""
        }

        if let retailer_twitter = String((result["retailer_twitter"] as? String)!){
            self.retailer_twitter = retailer_twitter
        }
        else{
            self.retailer_twitter = ""
        }

        if let retailer_website = String((result["retailer_website"] as? String)!){
            self.retailer_website = retailer_website
        }
        else{
            self.retailer_website = ""
        }

        if let description = String((result["description"] as? String)!){
            self.description = description
        }
        else{
            self.description = ""
        }

        if let currency = result["currency"] as? String{
            self.currency = currency
        }
        else{
            self.currency = ""
        }

        if let url = String((result["url"] as? String)!){
            self.url = url
        }
        else{
            self.url = ""
        }

        if let gallery = result["gallery"] as? [String]!{
            self.gallery = gallery
        }
        else{
            self.gallery = []
        }
        
        if let gallery_cropped = result["gallery_cropped"] as? [String]!{
            self.gallery_cropped = gallery_cropped
        }
        else{
            self.gallery_cropped = []
        }


        if let featured = String((result["featured"] as? String)!){
            self.featured = featured
        }
        else{
            self.featured = ""
        }
        
        if let featured_cropped = String((result["featured_cropped"] as? String)!){
            self.featured_cropped = featured_cropped
        }
        else{
            self.featured_cropped = ""
        }

        
        
    }
    
    func load_image(urlString:String,onComplete: @escaping (_ image:UIImage?,_ status:String) -> Void)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                if let im = UIImage(data: data!) {
                    onComplete(im,"ok")
                }
            }else{
                onComplete(nil,"error")
            }
        })
        task.resume()
    }


}




//"offer_id": "100",
//"offer_name": "50% Discount on Full Body Laser",
//"offer_description": "<p>50% Discount on Full Body Laser Hair Removal</p><p style:\"\">If you're not happy with shaving, tweezing, or waxing to remove unwanted hair, laser hair removal may be an option worth considering. </p><p style:\"\">Laser hair removal is one of the most commonly done cosmetic procedures in the world. It beams highly concentrated light into hair follicles. Pigment in the follicles absorb the light. That destroys the hair. </p><p><br></p>",
//"offer_summary": "",
//"issue_date": "2017-06-01",
//"expiry_date": "2018-11-01",
//"validity": "All Days",
//"frequency": "Unlimited",
//"original_price": "0",
//"discount_price": "0",
//"sub_category": [
//{
//"sub_category_name": "SPA",
//"category_name": "Beauty & Spa"
//}
//],
//"branches": [
//{
//"branch_name": "Kimantra Spa Dbaye",
//"branch_location": "Dbaye Lebanon",
//"branch_phone_number": "04546654",
//"branch_mobile_number": "03546654",
//"latitude": "33.9367",
//"longitude": "35.5912"
//},
//{
//"branch_name": "Kimantra Spa Beirut",
//"branch_location": "Downtown Beirut",
//"branch_phone_number": "01999595",
//"branch_mobile_number": "71999595",
//"latitude": "33.8988",
//"longitude": "35.5067"
//}
//],
//"retailer_name": "Kimantra Spa",
//"retailer_logo": "http://privileb.com/admin_portal/images/retailers/ee073aea8ee96cf36f281b609b0d94da.png",
//"retailer_insta": "",
//"retailer_fb": "https://www.facebook.com/pg/kimantraspa/",
//"retailer_twitter": "",
//"retailer_website": "http://www.kimantraspa.com/",
//"description": "Mantra is anything used for a good purpose, for meditation, protection and healing.\r\n It is a prayer, a song, a smell, a voice, a taste, an image or a touch \r\nthat heals you and eliminates not only pain from diseases but also helps\r\n you in overcoming inner sickness of attachment, hatred, jealousy, \r\ndesire, greed and ignorance. Therefore, the word KiMantra in its most literal sense means \"to free from the mind\" using the Ki.  It is when we use our energies and thoughts to assist others in finding their balance and harmony..  Free your mind and surrender to our personalized treatments KiMantra is a place of relaxation that features the worldÃ¢â¬â¢s most famous and beneficial treatments from 8 different countries. \r\n Desiring to introduce to women and men the healing art of massage, our \r\ntreatments stay true to the spirits of traditions and offer you a \r\nrefreshingly unique perspective that makes KiMantra so much more than a \r\nspaÃ¢â¬Â¦",
//"currency": null,
//"url": "http://privileb.com/offer/100",
//"gallery": [
//"http://privileb.com/admin_portal/images/offers/5938045640158.jpg",
//"http://privileb.com/admin_portal/images/offers/59380464524c7.jpg",
//"http://privileb.com/admin_portal/images/offers/5942625be723c.jpg"
//],
//"gallery_cropped": [
//"http://privileb.com/admin_portal/images/offers/application/thumb_5938045640158.jpg",
//"http://privileb.com/admin_portal/images/offers/application/thumb_59380464524c7.jpg",
//"http://privileb.com/admin_portal/images/offers/application/thumb_5942625be723c.jpg"
//],
//"featured": "http://privileb.com/admin_portal/images/offers/5942625c01652.jpg",
//"featured_cropped": "http://privileb.com/admin_portal/images/offers/application/thumb_5942625c01652.jpg"
//}
