//
//  OfferMapView.swift
//  Privileb
//
//  Created by SSS on 6/30/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class OfferMapView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var retailerNameLabel: UILabel!

    override func draw(_ rect: CGRect) {
        self.containerView.layer.cornerRadius = 5
        
    }
 

    func cofigureView(offer:offer)  {
        self.load_image(urlString: offer.featured_cropped)
        self.offerNameLabel.text = offer.offer_name
        self.retailerNameLabel.text = offer.retailer_name
    }
    func load_image(urlString:String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil && data != nil {
                DispatchQueue.main.async(execute: {
                    if let im = UIImage(data: data!) {
                        self.offerImageView.image = im
                    }
                })
            }else{
                self.offerImageView.image = UIImage(named: "")
            }
        })
        task.resume()
    }

    
}
