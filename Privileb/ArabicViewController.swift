//
//  ArabicViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class ArabicViewController: UIViewController {
    var binifits:static_page?

    @IBOutlet weak var pageLabel: UITextView!
    @IBOutlet weak var pageImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.binifits = AppDelegate.sharedDelegate().binifits
        if binifits != nil {
            let attrStr = try! NSAttributedString(
                data: (binifits?.description_ar?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.pageLabel.textAlignment = .right
            self.pageLabel.text = attrStr.string
            //self.load_image(urlString: (binifits?.image)!)
        }
        // Do any additional setup after loading the view.
        self.pageLabel.setContentOffset(CGPoint.zero, animated: false)
        self.pageLabel.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    override func viewDidLayoutSubviews() {
        self.pageLabel.setContentOffset(CGPoint.zero, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.binifits = AppDelegate.sharedDelegate().binifits
        if binifits != nil {
            let attrStr = try! NSAttributedString(
                data: (binifits?.description_ar?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.pageLabel.textAlignment = .right
            self.pageLabel.text = attrStr.string
            //self.load_image(urlString: (binifits?.image)!)
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
