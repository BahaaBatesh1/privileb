//
//  PrivilebCardController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import MapKit
class PrivilebCardController: BaseViewController ,MFMailComposeViewControllerDelegate ,MKMapViewDelegate{

    @IBOutlet weak var myCardView: UIView!
    @IBOutlet weak var validationDateLabel: UILabel!
    @IBOutlet weak var holderNameLabel: UILabel!
    @IBOutlet weak var cardSerialNumberLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
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
    let userDefaults = UserDefaults.standard
    var card : card?
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false


        if let isLogedIn = userDefaults.value(forKey: "isLogedIn") as? Bool{
            if isLogedIn {
                AppDelegate.sharedDelegate().loadCard()
                self.card = AppDelegate.sharedDelegate().card
                self.cardSerialNumberLabel.text = self.card?.serial_number
                self.holderNameLabel.text = self.card?.cardHolderName
                self.validationDateLabel.text = self.card?.expiry_date
                self.currentTitlelabel.text = self.card?.cardHolderName
                self.myCardView.isHidden = false
                self.buCardView.isHidden = true
                isHaveCard = true
                var serial = userDefaults.value(forKey: "serial_number") as! String

                let four_digits : String = (serial.substring(from:(serial.index((serial.endIndex), offsetBy: -4))));
                self.secondImage.image = generateQRCodeFromString(user_id: four_digits)
            }else{
                self.myCardView.isHidden = true
                self.buCardView.isHidden = false
                isHaveCard = false
                self.currentTitlelabel.text = "PRIVILEB CARD"
            }
        }else{
            self.myCardView.isHidden = true
            self.buCardView.isHidden = false
            isHaveCard = false
            self.currentTitlelabel.text = "PRIVILEB CARD"
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude:33.883201,longitude:35.560304)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation =  MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude:33.883201 ,longitude:35.560304)
        self.mapView.addAnnotation(annotation)

        
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
            self.joinPageLabel.text = attrStr.string
           // self.load_image(urlString: (joinOur?.image)!)
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let isLogedIn = userDefaults.value(forKey: "isLogedIn") as? Bool{
            if isLogedIn {
                self.card = AppDelegate.sharedDelegate().card
                self.cardSerialNumberLabel.text = self.card?.serial_number
                self.holderNameLabel.text = self.card?.cardHolderName
                self.validationDateLabel.text = self.card?.expiry_date
                self.currentTitlelabel.text = self.card?.cardHolderName
                self.myCardView.isHidden = false
                self.buCardView.isHidden = true
                isHaveCard = true
            }else{
                self.myCardView.isHidden = true
                self.buCardView.isHidden = false
                isHaveCard = false
                self.currentTitlelabel.text = "PRIVILEB CARD"
            }
        }else{
            self.myCardView.isHidden = true
            self.buCardView.isHidden = false
            isHaveCard = false
            self.currentTitlelabel.text = "PRIVILEB CARD"
        }

        
        
        
        self.joinOur = AppDelegate.sharedDelegate().joinOur
        if joinOur != nil {
            let attrStr = try! NSAttributedString(
                data: (joinOur?.description?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.joinPageLabel.text = attrStr.string
           // self.load_image(urlString: (joinOur?.image)!)
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
            self.currentTitlelabel.text = self.card?.cardHolderName
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
        performSegue(withIdentifier: "toBuyCard", sender: self)
    }
    @IBAction func onHotLine(_ sender: Any) {
        let alertController = UIAlertController(title: "Call hot line", message: "81717272", preferredStyle: .alert)
        let call = UIAlertAction(title: "Call", style: .default) { (alert) in
            if let url = NSURL(string: "tel://81717272") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(NSURL(string: "tel://81717272") as! URL)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(call)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func onDropMessage(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func onGetDirection(_ sender: Any) {
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        let gMapsBtn = UIAlertAction(title: "Google maps", style: .default) { (action) in
            UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=33.883201,35.560304&directionsmode=driving")! as URL) // Also from sumesh's answer
        }
        let appleMaps = UIAlertAction(title: "Maps", style: .default) { (action) in
            self.openMapForPlace()
        }
        alert.addAction(gMapsBtn)
        alert.addAction(appleMaps)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    func openMapForPlace() {
        
        let lat1 : NSString = "33.883201" as NSString
        let lng1 : NSString = "35.560304" as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Privileb"
        mapItem.openInMaps(launchOptions: options)
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@privileb.com"])
        mailComposerVC.setSubject("subject")
        mailComposerVC.setMessageBody("Body", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func generateQRCodeFromString(user_id : String) -> UIImage?{
        
        let string_to_encode = user_id
        let data = string_to_encode.data(using: String.Encoding.ascii, allowLossyConversion: false)
        //let serial_number1 = user_id.data(using: String.Encoding.ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
      //  filter?.setValue(serial_number1, forKey: "inputCorrectionLevel")

        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.applying(transform)
        if(output != nil){
            return UIImage(ciImage: output!)
        }
        return nil
        
    
    
    }

}
