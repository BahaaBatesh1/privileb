//
//  FirstViewController.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import Kingfisher

class FirstViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var loaderView: UIView!
    var loader: MaterialLoadingIndicator!
    @IBOutlet weak var tableView: UITableView!
    let services = services_calls()
    var offers : [offer] = []
    var sselectedOffer : offer?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FirstViewController.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)
        callService()

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        if isLoading == false && offers.count == 0 {
            callService()
        }
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
        
        let url = URL(string: self.offers[indexPath.row].featured_cropped)
        cell.logoImage!.kf.setImage(with: url, placeholder: UIImage(named: "enptyCell"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.sliderLabel.text = self.offers[indexPath.row].frequency
        cell.categoryLabel.text = "   " + self.offers[indexPath.row].category + "   "
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
    
    func callService()  {
        isLoading = true
        self.tableView.isHidden = true
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_featured_offers(country_code: "lb", date: NSDate().getToDay(),onComplete: {
            (offers , status,postRes) -> Void in
            if status == "ok"{
                if postRes?.status == 1{
                    self.isLoading = false
                    self.offers = offers!
                    AppDelegate.sharedDelegate().filterOffers = offers!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fillOffers"), object: nil)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        self.tableView.isHidden = false
                        self.refreshControl.endRefreshing()
                    }
                }else{
                    self.isLoading = false
                    self.tableView.isHidden = false
                    self.refreshControl.endRefreshing()

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
                self.isLoading = false
                self.tableView.isHidden = false
                self.refreshControl.endRefreshing()

                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                print("error")
            }
        })
    }
    
    func handleRefresh()  {
        services.get_featured_offers(country_code: "lb", date: NSDate().getToDay(),onComplete: {
            (offers , status,postRes) -> Void in
            if status == "ok"{
                if postRes?.status == 1{
                    self.offers = offers!
                    AppDelegate.sharedDelegate().filterOffers = offers!
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fillOffers"), object: nil)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }else{
                    self.refreshControl.endRefreshing()
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
                self.refreshControl.endRefreshing()
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        })

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

