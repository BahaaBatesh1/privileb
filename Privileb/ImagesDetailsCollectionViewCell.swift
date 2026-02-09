//
//  ImagesDetailsCollectionViewCell.swift
//  Privileb
//
//  Created by SSS on 7/4/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class ImagesDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!

func load_image(urlString:String)
{
    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
    let session = URLSession.shared
    request.httpMethod = "GET"
    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        if error == nil && data != nil {
            DispatchQueue.main.async(execute: {
                if let im = UIImage(data: data!) {
                    self.cellImage.image = im
                }
            })
        }else{
            self.cellImage.image = UIImage(named: "")
        }
    })
    task.resume()
}
}
