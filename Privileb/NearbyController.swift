//
//  NearbyController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import MapKit
class NearbyController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var view_type: UIView!
    var sselectedOffer : offer?
    @IBOutlet weak var mapKitView: MKMapView!
    var offers : [offer] = []
    var services = services_calls()
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var viewListTitleBtn: UIButton!
    @IBOutlet weak var viewListBtn: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locationManager.location!
        }
        mapKitView.delegate = self
        mapKitView.showsUserLocation = true
        mapKitView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKitView.setRegion(region, animated: true)

        //Zoom to user location
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }

        
        //load near by
        callService()
        // Do any additional setup after loading the view.
        
        //add gesture to view over viewtype buttons
        
        let gestture = UITapGestureRecognizer(target: self, action: #selector(NearbyController.onGesture))
        self.view_type.addGestureRecognizer(gestture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "test")
        
        if annotationView == nil {
            annotationView = OfferAnnotationView(annotation: annotation, reuseIdentifier: "test")
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       let sender = (view as! OfferAnnotationView)
        print((sender.annotation as! OfferAnnotation).offer.offer_name)
        self.sselectedOffer = (sender.annotation as! OfferAnnotation).offer
        performSegue(withIdentifier: "toDetailsFromNear", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearByCell") as! FeaturedTableViewCell
        cell.dateLabel.text = "\(self.offers[indexPath.row].issue_date!) to \(self.offers[indexPath.row].expiry_date!)"
        cell.supervisedByLabel.text = self.offers[indexPath.row].retailer_name
        cell.offerLabel.text = self.offers[indexPath.row].offer_name
        if self.offers[indexPath.row].featured_croppedImage != nil {
            cell.logoImage.image = self.offers[indexPath.row].featured_croppedImage
        }else{
            cell.load_image(urlString: self.offers[indexPath.row].featured_cropped)
        }
        cell.sliderLabel.text = self.offers[indexPath.row].frequency
        cell.categoryLabel.text = " Beauty & spa  "

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sselectedOffer = self.offers[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromNear", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromNear" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = (self.sselectedOffer?.offer_id)!
        }
    }
    
    @IBAction func onFilter(_ sender: Any) {
        performSegue(withIdentifier: "toFilterFromNearby", sender: self)
    }
    @IBAction func onViewList(_ sender: Any) {
        if self.mapView.isHidden {
            self.viewListTitleBtn.setTitle("View list", for: .normal)
            self.viewListBtn.setImage(UIImage(named: "nearby_list3"), for: .normal)
            self.mapView.isHidden = false
            self.listView.isHidden = true
            self.tableView.reloadData()
        }else{
            self.viewListTitleBtn.setTitle("View map", for: .normal)
            self.viewListBtn.setImage(UIImage(named: "nearby_capture3"), for: .normal)
            self.mapView.isHidden = true
            self.listView.isHidden = false
        }
    }

    @IBAction func onViewListTitle(_ sender: Any) {
        if self.mapView.isHidden {
            self.viewListTitleBtn.setTitle("View list", for: .normal)
            self.viewListBtn.setImage(UIImage(named: "nearby_list3"), for: .normal)
            self.mapView.isHidden = false
            self.listView.isHidden = true
            
        }else{
            self.viewListTitleBtn.setTitle("View map", for: .normal)
            self.viewListBtn.setImage(UIImage(named: "nearby_capture3"), for: .normal)
            self.mapView.isHidden = true
            self.listView.isHidden = false
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func callService()  {
        // loading nearby7¶¶¶¶
        services.get_nearby_offers(latitude: currentLocation.coordinate.latitude.description, longtude: currentLocation.coordinate.longitude.description, date: NSDate().getToDay()) { (offers, status,postRes) in
            if status == "ok"{
                if postRes?.status == 1 {
                    DispatchQueue.main.async {
                        self.offers = offers!
                        self.tableView.reloadData()
                        for of in offers! {
                            let location = CLLocationCoordinate2D(latitude: of.branches[0].latitude,longitude: of.branches[0].longtude )
                            let annotation = OfferAnnotation(offer: of, coordinate: location, image: UIImage())
                            self.mapKitView.addAnnotation(annotation)
                        }
                    }
                }else{
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
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                print("erorr serveice")
            }
        }
        
        
        
        
    }
    
    
    func onGesture (){
        onViewList(self)
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
