//
//  FeaturedTableViewCell.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loveBtn: UIButton!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var supervisedByLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var logoImageLoaded: UIImage?
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 0
        containerView.layer.masksToBounds = true
        topView.layer.masksToBounds = true
        bottomView.layer.masksToBounds = true
        self.categoryLabel.layer.cornerRadius = 4
        self.categoryLabel.sizeToFit()
        self.categoryLabel.layer.masksToBounds = true
        
        let mGradient = CAGradientLayer()
        mGradient.masksToBounds = true
        mGradient.frame = self.logoImage.bounds
        var colors = [CGColor]()
        colors.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).cgColor)
        colors.append(UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor)
        
        mGradient.startPoint = CGPoint(x: 0.0, y: 1)
        mGradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        mGradient.colors = colors
        
        self.logoImage.layer.addSublayer(mGradient)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                        self.logoImage.image = im
                        self.logoImageLoaded = im
                    }
                })
            }else{
                self.logoImage.image = UIImage(named: "background")
            }
        })
        task.resume()
    }

}
