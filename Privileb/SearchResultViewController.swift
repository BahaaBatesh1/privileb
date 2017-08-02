//
//  SearchResultViewController.swift
//  Privileb
//
//  Created by SSS on 7/6/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import Kingfisher


class SearchResultViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    var result :[offer] = []
    var selectedResult : offer?
    let services = services_calls()
    var loader: MaterialLoadingIndicator!
    var category_ids :String!
    var district_ids: String!
    var keyword :String!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)

        callService()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell") as! FeaturedTableViewCell
        cell.dateLabel.text = "\(self.result[indexPath.row].issue_date!) to \(self.result[indexPath.row].expiry_date!)"
        cell.supervisedByLabel.text = self.result[indexPath.row].retailer_name
        cell.offerLabel.text = self.result[indexPath.row].offer_name
        
        
        let url = URL(string: self.result[indexPath.row].featured_cropped)
        cell.logoImage!.kf.setImage(with: url, placeholder: UIImage(named: "enptyCell"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.sliderLabel.text = self.result[indexPath.row].frequency
        cell.categoryLabel.text = "   " + self.result[indexPath.row].category + "   "

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedResult = self.result[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromResults", sender: self)
    }
    @IBAction func onBackBtn(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
        if let search = self.navigationController?.viewControllers[0] as? FilterViewController {
            search.resultLabel.text = "\(self.result.count) Offer"
            search.searchResult = self.result
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromResults" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = self.selectedResult?.offer_id
        }
    }
    func callService()  {
        self.loaderView.isHidden = false
        self.loader.startAnimating()
        services.search_offers(category_ids: category_ids, country_code: "lb", date: NSDate().getToDay(), district_ids:district_ids, keyword: keyword) {
            (offers, status,postRes) in
            if status == "ok" {
                if postRes?.status == 1 {
                    DispatchQueue.main.async {
                        self.result = offers!
                        self.tableView.reloadData()
                        self.loaderView.isHidden = true
                        self.loader.stopAnimating()
                    }
                }else{
                    self.loaderView.isHidden = true
                    self.loader.stopAnimating()
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
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                print("error service")
            }
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

}
