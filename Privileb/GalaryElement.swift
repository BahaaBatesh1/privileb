//
//  GalaryElement.swift
//  Privileb
//
//  Created by SSS on 7/6/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
import UIKit

class GalaryElement {
    var link:String!
    var image:UIImage?
    
    func load_image(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                DispatchQueue.main.async(execute: {
                    if let im = UIImage(data: data!) {
                        self.image = im
                    }
                })
            }else{
                self.image = UIImage(named: "")
            }
        })
        task.resume()
    }

}
