//
//  PrivilebCardController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class PrivilebCardController: BaseViewController {

    @IBOutlet weak var joinPageLabel: UILabel!
    @IBOutlet weak var joinPageImageView: UIImageView!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var buCardView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var dropMessageBtn: UIButton!
    @IBOutlet weak var hotlinBtn: UIButton!
    @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var contactLocationLabel: UILabel!
    @IBOutlet weak var contacView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var benefitsView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var benifitsBtn: UIButton!
    @IBOutlet weak var myCardBtn: UIButton!
    @IBOutlet weak var aboutPrivilpCardBtn: UIButton!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var currentTitlelabel: UILabel!
    var isdown = false
    var isHaveCard = false
    var joinOur:static_page?
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false

        let gesture = UITapGestureRecognizer(target: self, action: #selector(PrivilebCardController.onViewGesture(_:)))
        self.clearView.addGestureRecognizer(gesture)
        if isHaveCard {
            self.buCardView.isHidden = true
        }
        
        buyBtn.layer.cornerRadius = 5
        buyBtn.layer.borderColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        buyBtn.layer.borderWidth = 1
        
        hotlinBtn.layer.cornerRadius = 5
        hotlinBtn.layer.borderColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        hotlinBtn.layer.borderWidth = 1
        
        dropMessageBtn.layer.cornerRadius = 5
        dropMessageBtn.layer.borderColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        dropMessageBtn.layer.borderWidth = 1
        
        
        self.joinOur = AppDelegate.sharedDelegate().joinOur
        if joinOur != nil {
            let attrStr = try! NSAttributedString(
                data: (joinOur?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.joinPageLabel.attributedText = attrStr
            self.load_image(urlString: (joinOur?.image)!)
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.joinOur = AppDelegate.sharedDelegate().joinOur
        if joinOur != nil {
            let attrStr = try! NSAttributedString(
                data: (joinOur?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.joinPageLabel.attributedText = attrStr
            self.load_image(urlString: (joinOur?.image)!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAbout(_ sender: Any) {
        self.currentTitlelabel.text = "ABOUT PRIVILEB CARD"
        hidOther(view: self.aboutView)
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
    }
    @IBAction func onMyCard(_ sender: Any) {
        if isHaveCard{
            self.currentTitlelabel.text = "MRS. RITA ASSI"
        }else{
            self.currentTitlelabel.text = "PRIVILEB CARD"
        }
        hidOther(view: self.mainView)
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
    }
    @IBAction func onBenifits(_ sender: Any) {
        self.currentTitlelabel.text = "BENEFITS"
        hidOther(view: self.benefitsView)
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
    }
    @IBAction func onTerms(_ sender: Any) {
        self.currentTitlelabel.text = "TERMS & CONDITIONS"
        hidOther(view: self.termsView)
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
    }
    @IBAction func onContact(_ sender: Any) {
        self.currentTitlelabel.text = "CONTACT US"
        hidOther(view: self.contacView)
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
    }
    @IBAction func onDropDown(_ sender: Any) {
        if isdown{
            self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
            self.dropView.isHidden = true
            isdown = false
        }else{
            self.dropDownBtn.setImage(UIImage(named: "disclouser_mark1"), for: .normal)
            self.dropView.isHidden = false
            isdown = true
        }
    }

    @IBAction func onMenuBtn(_ sender: Any) {
        if slidingPanelController.sideDisplayed == MSSPSideDisplayed.left {
            slidingPanelController.closePanel()
        } else {
            slidingPanelController.openLeftPanel()
        }

    }
    
    @IBAction func onBuy(_ sender: Any) {
    }
    @IBAction func onHotLine(_ sender: Any) {
    }
    @IBAction func onDropMessage(_ sender: Any) {
    }
    @IBAction func onGetDirection(_ sender: Any) {
    }
    func hidOther(view: UIView)  {
        if view == self.aboutView {
            self.aboutView.isHidden = false
        }else{
            self.aboutView.isHidden = true
        }
        
        if view == self.mainView {
            self.mainView.isHidden = false
        }else{
            self.mainView.isHidden = true
        }
        
        if view == self.benefitsView {
            self.benefitsView.isHidden = false
        }else{
            self.benefitsView.isHidden = true
        }
        
        if view == self.termsView {
            self.termsView.isHidden = false
        }else{
            self.termsView.isHidden = true
        }
     
        if view == self.contacView {
            self.contacView.isHidden = false
        }else{
            self.contacView.isHidden = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onViewGesture(_ sender:Any) {
        self.dropDownBtn.setImage(UIImage(named: "down_mark1"), for: .normal)
        self.dropView.isHidden = true
        isdown = false
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
                        self.joinPageImageView.image = im
                    }
                })
            }else{
                self.joinPageImageView.image = UIImage(named: "")
            }
        })
        task.resume()
    }
}
