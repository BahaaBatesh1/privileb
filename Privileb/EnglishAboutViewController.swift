//
//  EnglishAboutViewController.swift
//  Privileb
//
//  Created by SSS on 7/1/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class EnglishAboutViewController: UIViewController {
    @IBOutlet weak var pageImageView: UIImageView!
    var about:static_page?

    @IBOutlet weak var pageLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.about = AppDelegate.sharedDelegate().about
        if about != nil {
            let attrStr = try! NSAttributedString(
                data: (about?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            self.pageLabel.text = attrStr.string
           // self.load_image(urlString: (about?.image)!)
        }
        // Do any additional setup after loading the view.
        self.pageLabel.setContentOffset(CGPoint.zero, animated: false)
        self.pageLabel.scrollRangeToVisible(NSMakeRange(0, 0))

    }
    
    override func viewDidLayoutSubviews() {
 self.pageLabel.setContentOffset(CGPoint.zero, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.about = AppDelegate.sharedDelegate().about
        if about != nil {
            let attrStr = try! NSAttributedString(
                data: (about?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            self.pageLabel.text = attrStr.string
          //  self.load_image(urlString: (about?.image)!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        self.pageImageView.image = im
                    }
                })
            }else{
                self.pageImageView.image = UIImage(named: "")
            }
        })
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
