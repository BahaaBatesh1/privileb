//
//  SearchLocationViewController.swift
//  Privileb
//
//  Created by SSS on 6/29/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit


class SearchLocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    @IBOutlet weak var tableViwe: UITableView!
    var selectedDes : [district] = []
    var unSelectedDes : [district] = []
    
    var selectedCat : [categoryy] = []
    var unSelectedCat : [categoryy] = []
    
    var searchBarCat:[categoryy]?
    var searchBarDis:[district]?
    var fromCategories = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_backicon")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(SearchLocationViewController.onBack(_:)))

        
        self.unSelectedDes = AppDelegate.sharedDelegate().unSelectedDis
        self.unSelectedCat = AppDelegate.sharedDelegate().unSelectedCat
        
        self.selectedCat = AppDelegate.sharedDelegate().selectedCat
        self.selectedDes = AppDelegate.sharedDelegate().selectedDis

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.unSelectedDes = AppDelegate.sharedDelegate().unSelectedDis
        self.unSelectedCat = AppDelegate.sharedDelegate().unSelectedCat
        self.selectedCat = AppDelegate.sharedDelegate().selectedCat
        self.selectedDes = AppDelegate.sharedDelegate().selectedDis

        self.tableViwe.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            if fromCategories {
                return self.searchBarCat?.count ?? 0
            }else{
                return self.searchBarDis?.count ?? 0
            }
        }else{
            if fromCategories {
                if section == 0 {
                    return selectedCat.count
                }else{
                    return unSelectedCat.count
                }
            }else{
                if section == 0 {
                    return selectedDes.count
                }else{
                    return unSelectedDes.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let lable = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 50))
        if tableView != self.searchDisplayController?.searchResultsTableView{
            
            if fromCategories {
                if section == 0 {
                    lable.text = "SELECTED CATEGORY"
                }else{
                    lable.text = "SEARCH BY"
                }
            }else{
                if section == 0 {
                    lable.text = "SELECTED AREA"
                }else{
                    lable.text = "SEARCH BY"
                }
            }
            lable.textColor = UIColor.darkGray
            view.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
            lable.font = lable.font.withSize(12)
            view.addSubview(lable)
            return view
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != self.searchDisplayController?.searchResultsTableView{
            return 50
        }
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchDisplayController?.searchResultsTableView{
            if fromCategories {
                if indexPath.section == 0 {
                    let cell = self.tableViwe.dequeueReusableCell(withIdentifier: "searchLocationCell") as! SearchLocationTableViewCell
                    cell.celllabel.text = searchBarCat?[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_search3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 400
                    return cell
                }
            }else{
                if indexPath.section == 0 {
                    let cell = self.tableViwe.dequeueReusableCell(withIdentifier: "searchLocationCell") as! SearchLocationTableViewCell
                    cell.celllabel.text = searchBarDis?[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_search3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 400
                    return cell
                }
            }
        }else{
            if fromCategories {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchLocationCell") as! SearchLocationTableViewCell
                if indexPath.section == 0 {
                    cell.celllabel.text = selectedCat[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_area3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 100
                }else{
                    cell.celllabel.text = unSelectedCat[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_search3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 200
                }
                return cell

            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchLocationCell") as! SearchLocationTableViewCell
                if indexPath.section == 0 {
                    cell.celllabel.text = selectedDes[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_area3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 100
                }else{
                    cell.celllabel.text = unSelectedDes[indexPath.row].name
                    cell.cellBtn.setBackgroundImage(UIImage(named: "location_search3"), for: .normal)
                    cell.cellBtn.tag = indexPath.row
                    cell.contentView.tag = 200
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = (self.tableViwe.cellForRow(at: indexPath)) as! SearchLocationTableViewCell
        self.onCellBtn(cell.cellBtn)
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        if fromCategories {
            AppDelegate.sharedDelegate().selectedCat = self.selectedCat
            AppDelegate.sharedDelegate().unSelectedCat = self.unSelectedCat
        }else{
            AppDelegate.sharedDelegate().selectedDis = self.selectedDes
            AppDelegate.sharedDelegate().unSelectedDis = self.unSelectedDes
        }
    }
    @IBAction func onCellBtn(_ sender: UIButton) {
        
        if fromCategories {
            if sender.superview?.tag == 400 {
                var element = self.searchBarCat?.remove(at: sender.tag)
                self.selectedCat.append(self.removeFromUnselectedCat(cat: element!)!)
                self.searchDisplayController?.searchResultsTableView.reloadData()
            }
            if sender.superview?.tag == 100 {
                self.unSelectedCat.append(self.selectedCat.remove(at: sender.tag))
            }else if sender.superview?.tag == 200{
                self.selectedCat.append(self.unSelectedCat.remove(at: sender.tag))
            }
            self.tableViwe.reloadData()
        }else{
            if sender.superview?.tag == 400 {
                var element = self.searchBarDis?.remove(at: sender.tag)
                self.selectedDes.append(self.removeFromUnselected(dis: element!)!)
                self.searchDisplayController?.searchResultsTableView.reloadData()
            }
            if sender.superview?.tag == 100 {
                self.unSelectedDes.append(self.selectedDes.remove(at: sender.tag))
            }else if sender.superview?.tag == 200{
                self.selectedDes.append(self.unSelectedDes.remove(at: sender.tag))
            }
            self.tableViwe.reloadData()
        }
        
    }

    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if fromCategories {
            if self.unSelectedCat == nil {
                self.searchBarCat = nil
                return
            }
            self.searchBarCat =  self.unSelectedCat.filter({ (test) -> Bool in
                return (test.name.lowercased().range(of: searchText.lowercased()) != nil)
            })
        }else{
            if self.unSelectedDes == nil {
                self.searchBarDis = nil
                return
            }
            self.searchBarDis =  self.unSelectedDes.filter({ (test) -> Bool in
                return (test.name.lowercased().range(of: searchText.lowercased()) != nil)
            })
        }

    }
    
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        let searchString = controller.searchBar.text
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }
    
    
    func removeFromUnselected(dis :district) -> district? {
        var i = 0
        for el in self.unSelectedDes{
            if el.district_id == dis.district_id {
                return self.unSelectedDes.remove(at: i)
            }
            i = i + 1
        }
        return nil
    }
    
    func removeFromUnselectedCat(cat :categoryy) -> categoryy? {
        var i = 0
        for el in self.unSelectedCat{
            if el.category_id == cat.category_id {
              return  self.unSelectedCat.remove(at: i)
            }
            i = i + 1
        }
        return nil
    }
}
