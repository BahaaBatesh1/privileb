import UIKit
import MapKit
import Social
class FeaturedDetailsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,MKMapViewDelegate{
    
    @IBOutlet weak var alldetailsView: UIView!
    @IBOutlet weak var allDetailsTextView: UITextView!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var retailerNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var branchesCollectionView: UICollectionView!
    @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var loaderView: UIView!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var favoritBtnRight: UIButton!
    @IBOutlet weak var supervisedImage: UIImageView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var cateoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var offerId :Int?
    let services = services_calls()
    var detailedOffer : offer_details!
    var loader: MaterialLoadingIndicator!
    var offerImages:[String] = []
    var offerImagesObject:[GalaryElement] = []
    @IBOutlet weak var validatyValueLabel: UILabel!
    var branches : [branch] = []
    var selectedBranch:branch?
    var isLogedIn = false
    let userDefaults = UserDefaults.standard
    var uid :Int?
    var isfav = false
    var favorite :favourite?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cateoryLabel.sizeToFit()
        scrollView.contentSize=CGSize(width: 320,height: 1900);
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        
        
        if let log = userDefaults.value(forKey: "isLogedIn") as? Bool{
            self.isLogedIn = log
        }
        
        if isLogedIn {
            self.favoritBtnRight.isHidden = false
            self.retailerNameLabel.isHidden = true
            uid = userDefaults.value(forKey: "userId") as! Int
            isfavorite()
        }else{
            self.favoritBtnRight.isHidden = true
            self.retailerNameLabel.isHidden = false
        }
        
        
        
        // if not favorite
        favoritBtnRight.setImage(UIImage(named: "offer_favorite3"), for: .normal)
        
        callService()
        
        let attrs = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15.0),
            NSForegroundColorAttributeName : UIColor.black,
            NSUnderlineStyleAttributeName : 1] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Get direction", attributes:attrs)
        attributedString.append(buttonTitleStr)
        getDirectionBtn.setAttributedTitle(attributedString, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        let alert = UIAlertController(title: "Selection", message: "Select Share App", preferredStyle: .actionSheet)
        let gMapsBtn = UIAlertAction(title: "FaceBook", style: .default) { (action) in
          //facebook social
            if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                socialController?.setInitialText(self.detailedOffer!.offer_name!)
                socialController?.add(self.supervisedImage.image)
                //            socialController.addURL(someNSURLInstance)
                
                self.present(socialController!, animated: true, completion: nil)
            }
        }
        let appleMaps = UIAlertAction(title: "Twitter", style: .default) { (action) in
           //twitter social
            
            if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
                let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                socialController?.setInitialText(self.detailedOffer!.offer_name!)
                socialController?.add(self.supervisedImage.image)
                //            socialController.addURL(someNSURLInstance)
                
                self.present(socialController!, animated: true, completion: nil)
            }
        }
        let whatsapp = UIAlertAction(title: "Whatsapp", style: .default) { (action) in
            let urlString = self.detailedOffer.offer_name + " - " + self.detailedOffer.retailer_name
            let urlStringEncoded = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
            
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.openURL(url! as URL)
            } else {
                let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
        alert.addAction(gMapsBtn)
        alert.addAction(appleMaps)
        alert.addAction(whatsapp)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        self.favoritBtnRight.isEnabled = false
        
        if isfav{
            services.remove_from_favourite(favorite_id: favorite!.favorite_id.description, onComplete: { (res, status) in
                if status == "ok" {
                    if res?.status == 1 {
                        DispatchQueue.main.async {
                            self.favoritBtnRight.setImage(UIImage(named: "offer_favorite3"), for: .normal)
                            self.isfav = false
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.favoritBtnRight.isEnabled = true
                }
                self.favoritBtnRight.isEnabled = true
                
            })
        }else{
            services.add_to_favourite(user_id: self.uid!.description, datetime: NSDate().getToDay(), offer_id: self.offerId!.description) { (res,status) in
                if status == "ok"{
                    if res?.status == 1 {
                        DispatchQueue.main.async {
                            self.favoritBtnRight.setImage(UIImage(named: "offer_favorite_selected"), for: .normal)
                        }
                        self.isfav = true
                    }else{
                        DispatchQueue.main.async {
                            self.favoritBtnRight.setImage(UIImage(named: "offer_favorite3"), for: .normal)
                        }
                    }
                    self.favoritBtnRight.isEnabled = true
                }else{
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.favoritBtnRight.isEnabled = true
                }
            }
        }
        
    }
    
    
    @IBAction func onGetDeirection(_ sender: Any) {
        if self.selectedBranch != nil {
            let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
            let gMapsBtn = UIAlertAction(title: "Google maps", style: .default) { (action) in
                UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(self.selectedBranch!.latitude!),\(self.selectedBranch!.longtude!)&directionsmode=driving")! as URL) // Also from sumesh's answer
            }
            let appleMaps = UIAlertAction(title: "Maps", style: .default) { (action) in
                self.openMapForPlace()
            }
            alert.addAction(gMapsBtn)
            alert.addAction(appleMaps)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openMapForPlace() {
        
        let lat1 : NSString = self.selectedBranch!.latitude!.description as NSString
        let lng1 : NSString = self.selectedBranch!.longtude!.description as NSString
        
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
        mapItem.name = "\(self.selectedBranch!.name!)"
        mapItem.openInMaps(launchOptions: options)
        
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == branchesCollectionView {
            return self.branches.count
        }else{
            return self.offerImagesObject.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == branchesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchesDetailsCell", for: indexPath) as! BranchesDetailsCollectionViewCell
            if selectedBranch != nil {
                if self.branches[indexPath.row].name == selectedBranch?.name{
                    cell.branchName.textColor = UIColor.white
                    cell.branchName.backgroundColor = UIColor(red: 212, green: 172, blue: 92)
                    cell.branchName.text = self.branches[indexPath.row].name
                }else{
                    cell.branchName.textColor =  UIColor(red: 212, green: 172, blue: 92)
                    cell.branchName.backgroundColor = UIColor.white
                    cell.branchName.layer.borderColor = UIColor(red: 212, green: 172, blue: 92).cgColor
                    cell.branchName.layer.borderWidth = 1
                    cell.branchName.text = self.branches[indexPath.row].name
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCollectionCell", for: indexPath) as! ImagesDetailsCollectionViewCell
            if self.offerImagesObject[indexPath.row].image != nil {
                DispatchQueue.main.async {
                    cell.cellImage.image = self.offerImagesObject[indexPath.row].image
                }
            }else{
                DispatchQueue.main.async {
                    cell.load_image(urlString: self.offerImagesObject[indexPath.row].link)
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == branchesCollectionView {
            self.selectedBranch = self.branches[indexPath.row]
            self.locationLabel.text = "Location: " + (self.selectedBranch?.location!)!
            let location = CLLocationCoordinate2D(latitude: (self.selectedBranch?.latitude)!,longitude: (self.selectedBranch?.longtude)!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
            let annotation =  MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (self.selectedBranch?.latitude)!,longitude: (self.selectedBranch?.longtude)!)
            self.mapView.addAnnotation(annotation)
            self.branchesCollectionView.reloadData()
        }
    }
    
    
    @IBAction func onCall(_ sender: Any) {
        if selectedBranch != nil {
            if let url = NSURL(string: "tel://" + (self.selectedBranch?.branchPhone!)!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(url as URL)
                }
            }
        }
    }
    
    func load_image(urlString:String,imageView:UIImageView)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    imageView.image = UIImage(data: data!)
                })
            }else{
                imageView.image = UIImage(named: "")
            }
        })
        task.resume()
    }
    
    func callService()  {
        
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_offer_details(offer_id: "\(self.offerId!)") { (offerD, status,postRes) in
            if status == "ok"{
                if postRes?.status == 1{
                    DispatchQueue.main.async {
                        self.detailedOffer = offerD
                        var subCat = ""
                        var i = 0
                        for cat in (self.detailedOffer?.sub_categories)!{
                            if i == (self.detailedOffer?.sub_categories.count)! - 1 {
                                subCat.append(cat.name)
                            }else{
                                subCat = subCat + cat.name + " & "
                            }
                            i = i + 1
                        }
                        self.cateoryLabel.text = subCat
                        self.dateLabel.text = "From \(self.detailedOffer.issue_date!) To \(self.detailedOffer.expiry_date!)"
                        
                        let attrStr = try! NSAttributedString(
                            data: (self.detailedOffer.offer_description.data(using: String.Encoding.unicode, allowLossyConversion: false)!),
                            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                            documentAttributes: nil)
//                        let myAttribute = [ NSFontAttributeName: UIFont(name: UIFont.systemFontSize.description, size: 18.0)! ]
                        //let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)

                        

                        
                        if attrStr.string.utf16.count > 180{
                            self.seeMoreBtn.isHidden = false
                           let index =  attrStr.string.index(attrStr.string.startIndex, offsetBy: 180)
                            let sub = attrStr.string.substring(to: index)
                            self.descriptionLabel.text = sub
                            self.descriptionLabel.text?.append("...")
                            self.allDetailsTextView.text = attrStr.string
                        }else{
                            self.descriptionLabel.text = attrStr.string
                            self.seeMoreBtn.isHidden = true
                        }
                        
                        self.frequencyLabel.text = "Frequency: \(self.detailedOffer.frequency!)"
                        self.retailerNameLabel.text = self.detailedOffer.retailer_name
                        self.offerImages = self.detailedOffer.gallery_cropped!
                        self.offerImagesObject = self.detailedOffer.gallery_croppedObject
                        self.offerLabel.text = self.detailedOffer.offer_name
                        self.load_image(urlString: (self.detailedOffer.retailer_logo)!, imageView: self.supervisedImage)
                        self.validatyValueLabel.text = self.detailedOffer.validity
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        self.branches = self.detailedOffer.branches
                        self.selectedBranch = self.branches[0]
                        if self.selectedBranch != nil {
                            self.locationLabel.text = "Location: " + (self.selectedBranch?.location!)!
                            let location = CLLocationCoordinate2D(latitude: (self.selectedBranch?.latitude)!,longitude: (self.selectedBranch?.longtude)!)
                            let span = MKCoordinateSpanMake(0.05, 0.05)
                            let region = MKCoordinateRegion(center: location, span: span)
                            self.mapView.setRegion(region, animated: true)
                            let annotation =  MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: (self.selectedBranch?.latitude)!,longitude: (self.selectedBranch?.longtude)!)
                            self.mapView.addAnnotation(annotation)
                        }
                        self.imagesCollectionView.reloadData()
                        self.branchesCollectionView.reloadData()
                    }
                }else{
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    let alertController = UIAlertController(title: "Somthing went wrong!", message: postRes?.message, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                    let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: { (action) in
                        self.callService()
                    })
                    alertController.addAction(cancel)
                    alertController.addAction(tryAgain)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }else{
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                print("error")
            }
        }
    }
    
    func isfavorite()  {
        services.get_fav_by_uid_oid(user_id: (self.uid?.description)!, offer_id: (self.offerId?.description)!) { (res, status,fav) in
            if status == "ok" {
                if res?.status == 1{
                    DispatchQueue.main.async {
                        self.favoritBtnRight.setImage(UIImage(named: "offer_favorite_selected"), for: .normal)
                        self.isfav = true
                        self.favorite = fav
                    }
                }else{
                    // if not favorite
                    DispatchQueue.main.async {
                        self.favoritBtnRight.setImage(UIImage(named: "offer_favorite3"), for: .normal)
                        self.isfav = false
                    }
                }
            }else{
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onSeeMore(_ sender: Any) {
        self.alldetailsView.isHidden = false
    }
    
    @IBAction func onCancelSeeMor(_ sender: Any) {
        self.alldetailsView.isHidden = true
    }
}
