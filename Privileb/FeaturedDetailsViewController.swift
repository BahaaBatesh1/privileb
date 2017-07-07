//
//  FeaturedDetailsViewController.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import MapKit
class FeaturedDetailsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,MKMapViewDelegate{

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
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize=CGSize(width: 320,height: 2300);
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard


        
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
    }
 
    @IBAction func onFavorite(_ sender: Any) {
        services.add_to_favourite(user_id: "4", datetime: Date().description, offer_id: self.offerId!.description) { (res,status) in
            if status == "ok"{
                print(res?.message ?? 0)
            }else{
                print("service error")
            }
        }
        self.favoritBtnRight.setImage(UIImage(named: "offer_favorite_selected"), for: .normal)
    }
    
    
    @IBAction func onGetDeirection(_ sender: Any) {
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
                cell.cellImage.image = self.offerImagesObject[indexPath.row].image
            }else{
                cell.load_image(urlString: self.offerImagesObject[indexPath.row].link)
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
                        self.descriptionLabel.text = "Description: \(self.detailedOffer.description!)"
                        self.frequencyLabel.text = "Frequency: \(self.detailedOffer.frequency!)"
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
}
