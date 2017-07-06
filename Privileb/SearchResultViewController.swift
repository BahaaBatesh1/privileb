//
//  SearchResultViewController.swift
//  Privileb
//
//  Created by SSS on 7/6/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    var result :[offer] = []
    var selectedResult : offer?
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if self.result[indexPath.row].featured_croppedImage != nil {
            cell.logoImage.image = self.result[indexPath.row].featured_croppedImage
        }else{
            cell.load_image(urlString: self.result[indexPath.row].featured_cropped)
        }
        cell.sliderLabel.text = self.result[indexPath.row].frequency
        cell.categoryLabel.text = " Beauty & spa  "

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedResult = self.result[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromResults", sender: self)
    }
    @IBAction func onBackBtn(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromResults" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = self.selectedResult?.offer_id
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
