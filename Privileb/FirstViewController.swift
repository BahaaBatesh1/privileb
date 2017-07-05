//
//  FirstViewController.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var loaderView: UIView!
    var loader: MaterialLoadingIndicator!
    @IBOutlet weak var tableView: UITableView!
    let services = services_calls()
    var offers : [offer] = []
    var sselectedOffer : offer?
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.isHidden = true
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_featured_offers(country_code: "lb", date: "2017-05-09",onComplete: {
            (offers , status) -> Void in
            if status == "ok"{
                self.offers = offers!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    self.tableView.isHidden = false
                }
            }else{
                self.tableView.isHidden = false
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                print("error")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell") as! FeaturedTableViewCell
        cell.dateLabel.text = "\(self.offers[indexPath.row].issue_date!) to \(self.offers[indexPath.row].expiry_date!)"
        cell.supervisedByLabel.text = self.offers[indexPath.row].retailer_name
        cell.offerLabel.text = self.offers[indexPath.row].offer_name
        
        if self.offers[indexPath.row].featured_croppedImage != nil {
            cell.logoImage.image = self.offers[indexPath.row].featured_croppedImage
        }else{
            cell.load_image(urlString: self.offers[indexPath.row].featured_cropped)
        }
        cell.sliderLabel.text = self.offers[indexPath.row].frequency
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sselectedOffer = self.offers[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = (self.sselectedOffer?.offer_id)!
        }
    }
    
}

