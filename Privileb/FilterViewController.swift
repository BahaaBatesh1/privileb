//
//  FilterViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import Kingfisher


class FilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate, UISearchDisplayDelegate{
    var fromCat = false
    var selectedCat : [categoryy] = []
    var selectedDis : [district] = []
    var services = services_calls()
    var searchResult : [offer] = []
    var loader: MaterialLoadingIndicator!
    var category_ids = ""
    var district_ids = ""
    var searchBarResult:[offer]?
    var selectedOffer:offer?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)
        searchResult = AppDelegate.sharedDelegate().filterOffers
        resultLabel.text = "\(self.searchResult.count) Offer"
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectedCat = AppDelegate.sharedDelegate().selectedCat
        self.selectedDis = AppDelegate.sharedDelegate().selectedDis
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            return searchBarResult?.count ?? 0
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "resultsSearchCell") as! FeaturedTableViewCell
            cell.dateLabel.text = "\(self.searchBarResult![indexPath.row].issue_date!) to \(self.searchBarResult![indexPath.row].expiry_date!)"
            cell.supervisedByLabel.text = self.searchBarResult?[indexPath.row].retailer_name
            cell.offerLabel.text = self.searchBarResult?[indexPath.row].offer_name
            let url = URL(string: (self.searchBarResult?[indexPath.row].featured_cropped)!)
            cell.logoImage!.kf.setImage(with: url, placeholder: UIImage(named: "enptyCell"), options: nil, progressBlock: nil, completionHandler: nil)
//            if self.searchBarResult?[indexPath.row].featured_croppedImage != nil {
//                cell.logoImage.image = self.searchBarResult?[indexPath.row].featured_croppedImage
//            }else{
//                cell.load_image(urlString: (self.searchBarResult?[indexPath.row].featured_cropped)!)
//            }
            cell.sliderLabel.text = self.searchBarResult?[indexPath.row].frequency
            cell.categoryLabel.text = "   " + (self.searchBarResult?[indexPath.row].category)! + "   "
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
            if indexPath.row == 0 {
                cell.cellImage.image = UIImage(named: "filter_location3")
                cell.cellLabel.text = "Location"
            }else{
                cell.cellImage.image = UIImage(named: "filter_category3")
                cell.cellLabel.text = "Category"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let lable = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 50))
        if tableView != self.searchDisplayController?.searchResultsTableView{
            lable.text = "SEARCH BY"
            lable.textColor = UIColor.gray
            view.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
            lable.font = UIFont(name: "System", size: 3.0)
            view.addSubview(lable)
            return view
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != self.searchDisplayController?.searchResultsTableView{
            return 50
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            return 300
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            self.selectedOffer = self.searchBarResult?[indexPath.row]
            performSegue(withIdentifier: "toDetailsFromFilter" , sender: self)
        }else{
            if indexPath.row == 0 {
                fromCat = false
                performSegue(withIdentifier: "toLocationSearch", sender: self)
            }else{
                fromCat = true
                performSegue(withIdentifier: "toLocationSearch", sender: self)
            }
        }
    }
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        callService()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationSearch" {
            let des = segue.destination as! SearchLocationViewController
            des.fromCategories = fromCat
        }else if segue.identifier == "toResult" {
            let des = segue.destination as! SearchResultViewController
            des.category_ids = self.category_ids
            des.district_ids = self.district_ids
            des.keyword = (self.searchDisplayController?.searchBar.text)!
        }else if segue.identifier == "toDetailsFromFilter" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = (self.selectedOffer?.offer_id)!
        }
    }
    
    func callService()  {
         category_ids = ""
         district_ids = ""
        
        var i = 0
        for cat in selectedCat {
            if i == selectedCat.count - 1{
                category_ids.append("\(cat.category_id!)")
            }else{
                category_ids.append("\(cat.category_id!),")
            }
            i = i + 1
        }
        
        var j = 0
        for dis in selectedDis {
            if j == selectedDis.count - 1{
                district_ids.append("\(dis.district_id!)")
            }else{
                district_ids.append("\(dis.district_id!),")
            }
            j = j + 1
        }
        performSegue(withIdentifier: "toResult", sender: self)

    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if self.searchResult == nil {
            self.searchBarResult = nil
            return
        }
        self.searchBarResult =  self.searchResult.filter({ (test) -> Bool in
            return (test.offer_name.lowercased().range(of: searchText.lowercased()) != nil || test.retailer_name.lowercased().range(of: searchText.lowercased()) != nil)
        })
    }
    
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        let searchString = controller.searchBar.text
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }

    @IBAction func onShowResults(_ sender: Any) {
        callService()
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
