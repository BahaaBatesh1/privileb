//
//  FavorieViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FavorieViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate{
    var loader: MaterialLoadingIndicator!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loaderView: UIView!
    var searchResult : [favourite]?
    var favorites: [favourite] = []
    var services = services_calls()
    @IBOutlet weak var tableView: UITableView!
    var selectedOffer:favourite?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false
        if let txfSearchField = self.searchDisplayController?.searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = UIColor.white
            txfSearchField.layer.cornerRadius = 3
            txfSearchField.layer.masksToBounds = true
        }

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
        if tableView == self.searchDisplayController!.searchResultsTableView{
            return searchResult?.count ?? 0
        }else{
            return favorites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "favoritesimpleCell") as! FavoriteSimpleCell
        
        if tableView == self.searchDisplayController!.searchResultsTableView{
            cell.cellTitle.text = searchResult?[indexPath.row].offer_name
            cell.superVisedLabel.text = searchResult?[indexPath.row].retailer_name
        }else{
            cell.cellTitle.text = favorites[indexPath.row].offer_name
            cell.superVisedLabel.text = favorites[indexPath.row].retailer_name
            cell.dateLabel.text = "\(favorites[indexPath.row].issue_date!) to \(favorites[indexPath.row].expiry_date!)"
            cell.ultimateLabel.text = favorites[indexPath.row].frequency
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOffer = self.favorites[indexPath.row]
        performSegue(withIdentifier: "toDetailsFromFavorite", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsFromFavorite" {
            let des = (segue.destination as! UINavigationController).topViewController as! FeaturedDetailsViewController
            des.offerId = Int((self.selectedOffer?.offer_id)!)
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
    
    
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if self.favorites == nil {
            self.searchResult = nil
            return
        }
        self.searchResult =  favorites.filter({ (test) -> Bool in
            return (test.offer_name.lowercased().range(of: searchText.lowercased()) != nil)
        })
    }
    

    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        let searchString = controller.searchBar.text
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func callService()  {
        self.tableView.isHidden = true
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_favourite_list(user_id: "4", date: NSDate().getToDay()) { (favs, status,postRes) in
            if status == "ok"{
                if postRes?.status == 1{
                    self.favorites = favs!
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
                print("error")
            }
        }
    }
}
