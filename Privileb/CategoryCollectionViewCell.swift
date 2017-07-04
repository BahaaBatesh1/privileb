//
//  CategoryCollectionViewCell.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    func load_image(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                DispatchQueue.main.async(execute: {
                    if let im = UIImage(data: data!) {
                        self.categoryImage.image = im
                    }
                })
            }else{
                self.categoryImage.image = UIImage(named: "")
            }
        })
        task.resume()
    }
}
