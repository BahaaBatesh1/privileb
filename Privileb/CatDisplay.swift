//
//  CatDisplay.swift
//  Privileb
//
//  Created by SSS on 6/29/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation

class CatDisplay {
    var activeImage :UIImage = UIImage(named:"edu_selected")!
    var inActiveImage: UIImage = UIImage(named:"edu")!
    var mainImage: UIImage  = UIImage(named:"background")!
    var name:String = "loading"
    var isSelected = false
    
    func load_aimage(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                if let im = UIImage(data: data!) {
                    self.activeImage = im
                }
            }
        })
        task.resume()
    }
    
    func load_Inimage(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                if let im = UIImage(data: data!) {
                    self.inActiveImage = im
                }
            }
        })
        task.resume()
    }
    
    func load_Mimage(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil{
                if let im = UIImage(data: data!) {
                    self.mainImage = im
                }
            }
        })
        task.resume()
    }
}
    
