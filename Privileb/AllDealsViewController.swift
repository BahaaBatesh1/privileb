//
//  AllDealsViewController.swift
//  Privileb
//
//  Created by SSS on 6/20/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class AllDealsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    let services = services_calls()
    var offers : [offer] = []
    var sselectedOffer : offer?
    var loader: MaterialLoadingIndicator!

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        callService()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allDealsCell") as! FeaturedTableViewCell
        cell.dateLabel.text = "\(self.offers[indexPath.row].issue_date!) to \(self.offers[indexPath.row].expiry_date!)"
        cell.supervisedByLabel.text = self.offers[indexPath.row].retailer_name
        cell.offerLabel.text = self.offers[indexPath.row].offer_name
        
        if self.offers[indexPath.row].featured_croppedImage != nil {
            cell.logoImage.image = self.offers[indexPath.row].featured_croppedImage
        }else{
            cell.load_image(urlString: self.offers[indexPath.row].featured_cropped)
        }
        cell.sliderLabel.text = self.offers[indexPath.row].frequency
        cell.categoryLabel.text = "   " + self.offers[indexPath.row].category + "   "
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sselectedOffer = self.offers[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromAll", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromAll" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = (self.sselectedOffer?.offer_id)!
        }
    }

    func callService()  {
        loader.startAnimating()
        self.tableView.isHidden = true
        self.loaderView.isHidden = false
        services.get_all_offers(country_code: "lb", date: NSDate().getToDay(),onComplete: {
            (offers , status,postRes) -> Void in
            if status == "ok"{
                if postRes?.status == 1 {
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
                self.tableView.isHidden = false
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
