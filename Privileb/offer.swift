//
//  offer.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
import Kingfisher

class offer {

    var retailer_name : String!
    var offer_id : Int!
    var offer_name : String!
    
    var issue_date : String!
    var expiry_date : String!
    var validity : String!
    
    var frequency : String!
    var featured : String!
    var featuredImage: UIImage?
    var featured_cropped:String!
    var featured_croppedImage : UIImage?
    var branches : [branch] = []
    var category :String!
    init(reN:String,ofNam:String) {
        self.offer_name = ofNam
        self.retailer_name = reN
        self.featured_cropped = ""
    }
    
    init(result :[String: Any]) {
        
        if let offer_id = Int((result["offer_id"] as? String)!){
            self.offer_id = offer_id
        }else{
            self.offer_id = 0
        }
        
        if let retailer_name = result["retailer_name"] as? String{
            self.retailer_name = retailer_name
        }else{
            self.retailer_name = ""
        }
        
        if let offer_name = result["offer_name"] as? String{
            self.offer_name = offer_name
        }else{
            self.offer_name = ""
        }
        if let issue_date = result["issue_date"] as? String{
            self.issue_date = issue_date
        }else{
            self.issue_date = ""
        }
        
        if let expiry_date = result["expiry_date"] as? String{
            self.expiry_date = expiry_date
        }else{
            self.expiry_date = ""
        }
        
        if let validity = result["validity"] as? String{
            self.validity = validity
        }else{
            self.validity = ""
        }
        
        if let cat = result["category"] as? String{
            self.category = cat
        }else{
            self.category = ""
        }
        
        if let frequency = result["frequency"] as? String{
            self.frequency = frequency
        }else{
            self.frequency = ""
        }
        
        if let featured = result["featured"] as? String{
            self.featured = featured
          
//            load_image(urlString: featured, onComplete: { (image, status) in
//                if status == "ok" {
//                    DispatchQueue.main.async(execute: {
//                        self.featuredImage = image!
//                    })
//                }
//            })
        }else{
            self.featured = ""
        }
        
        if let featured_cropped = result["featured_cropped"] as? String{
            self.featured_cropped = featured_cropped

        }else{
            self.featured_cropped = "enptyCell"
        }
        
        if let br = result["branches"] as? [[String:Any]]{
            for b in br {
                self.branches.append(branch(result :b))
            }
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
    
//    func load_image(){
//    
//    
//    }
}

//
//"retailer_name": "Al Qasr",
//"offer_id": "21",
//"offer_name": "30% Discount on Total Bill",
//"issue_date": "2017-05-01",
//"expiry_date": "2018-11-01",
//"validity": "All Days",
//"frequency": "Unlimited",
//"featured": "http://privileb.com/admin_portal/images/offers/593faababdf06.jpg",
//"featured_cropped": "http://privileb.com/admin_portal/images/offers/application/thumb_593faababdf06.jpg"
