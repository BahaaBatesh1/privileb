//
//  CHViewController.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/12/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class CHViewController: BaseViewController {

    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var charity:static_page?
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = true

        let tapGesture1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CHViewController.onFirstImage))
        tapGesture1.cancelsTouchesInView = false
        firstImage.addGestureRecognizer(tapGesture1)

        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CHViewController.onsecondImage))
        tapGesture2.cancelsTouchesInView = false
        secondImage.addGestureRecognizer(tapGesture2)

        
        self.charity = AppDelegate.sharedDelegate().charity
        if charity != nil {
            let attrStr = try! NSAttributedString(
                data: (charity?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.descriptionLabel.attributedText = attrStr
           // self.load_image(urlString: (charity?.image)!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onFirstImage()  {
        UIApplication.shared.openURL(NSURL(string: "https://www.kidsfirstassociation.org/")! as URL)

    }
    
    func onsecondImage()  {
        UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/LebaneseAssociationforHemophilia/")! as URL)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
//    func load_image(urlString:String)
//    {
//        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
//        let session = URLSession.shared
//        request.httpMethod = "GET"
//        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//            if error == nil && data != nil {
//                DispatchQueue.main.async(execute: {
//                    if let im = UIImage(data: data!) {
//                        self.joinPageImageView.image = im
//                    }
//                })
//            }else{
//                self.joinPageImageView.image = UIImage(named: "")
//            }
//        })
//        task.resume()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
