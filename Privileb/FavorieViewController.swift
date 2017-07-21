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

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notLoginView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loaderView: UIView!
    var searchResult : [favourite]?
    var favorites: [favourite] = []
    var services = services_calls()
    let userDefaults = UserDefaults.standard
    var isLogedIn = false
    @IBOutlet weak var tableView: UITableView!
    var selectedOffer:favourite?
    var uid :Int?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FavorieViewController.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)

        loginBtn.layer.cornerRadius = 3
        
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

        
        
        if let log = userDefaults.value(forKey: "isLogedIn") as? Bool{
            self.isLogedIn = log
        }
        
        if isLogedIn {
            self.notLoginView.isHidden = true
            uid = userDefaults.value(forKey: "userId") as! Int
            callService()
        }else{
            self.notLoginView.isHidden = false
            self.loginBtn.isHidden = false
            self.loginLabel.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            if let log = userDefaults.value(forKey: "isLogedIn") as? Bool{
                self.isLogedIn = log
            }
            
            if isLogedIn {
                self.notLoginView.isHidden = true
                uid = userDefaults.value(forKey: "userId") as! Int
                if  isLoading == false && self.favorites.count == 0{
                    callService()
                }
            }else{
                self.notLoginView.isHidden = false
                self.loginBtn.isHidden = false
                self.loginLabel.isHidden = false
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
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
            return (test.offer_name.lowercased().range(of: searchText.lowercased()) != nil || test.retailer_name.lowercased().range(of: searchText.lowercased()) != nil)
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
        isLoading = true
        self.tableView.isHidden = true
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_favourite_list(user_id: (self.uid?.description)!, date: NSDate().getToDay()) { (favs, status,postRes) in
            if status == "ok"{
                if postRes?.status == 1{
                    self.favorites = favs!
                    self.isLoading = false
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        self.tableView.isHidden = false
                    }
                }else{
                    self.isLoading = false
                    self.tableView.isHidden = false
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true

                    self.notLoginView.isHidden = false
                    self.loginBtn.isHidden = true
                    self.loginLabel.isHidden = true
                }
            }else{
                self.isLoading = false
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
    
    func handleRefresh()  {
        services.get_favourite_list(user_id: (self.uid?.description)!, date: NSDate().getToDay()) { (favs, status,postRes) in
            if status == "ok"{
                if postRes?.status == 1{
                    self.favorites = favs!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }else{
                    self.favorites.removeAll()
                    self.refreshControl.endRefreshing()
                    self.notLoginView.isHidden = false
                    self.loginBtn.isHidden = true
                    self.loginLabel.isHidden = true
                }
            }else{
                self.refreshControl.endRefreshing()
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if #available(iOS 10.0, *) {
            AppDelegate.sharedDelegate().openLogin()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "loginNav")
            let rootController = UIApplication.shared.delegate?.window??.rootViewController as! MSSlidingPanelController
            rootController.centerViewController = controller
            rootController.closePanel()
        }
    }
    
    func removeFromList(id:String) {
        var i = 0
        for fav in favorites {
            if fav.offer_id == id {
                favorites.remove(at: i)
                break
            }
            i = i + 1
        }
        self.tableView.reloadData()
    }
}
