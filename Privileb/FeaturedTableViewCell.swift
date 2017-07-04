//
//  FeaturedTableViewCell.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loveBtn: UIButton!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var newBtn: UIButton!
    @IBOutlet weak var supervisedByLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        newBtn.layer.borderColor = UIColor(red: 220, green: 189, blue: 134).cgColor
        newBtn.layer.borderWidth = 1
        newBtn.layer.cornerRadius = 3
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        topView.layer.masksToBounds = true
        bottomView.layer.masksToBounds = true
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
                    }
                })
            }else{
                self.logoImage.image = UIImage(named: "")
            }
        })
        task.resume()
    }

}
