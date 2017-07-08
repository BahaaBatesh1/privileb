//
//  MenuViewController.swift
//  Privileb
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var taxi_view: UIView!
    @IBOutlet weak var call_view: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var callBtnView: UIView!
    var isFromReg = false
    let userDefaults = UserDefaults.standard
    var isLogedIn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        callBtnView.layer.cornerRadius = 2
        callBtnView.layer.borderWidth = 2
        callBtnView.layer.borderColor = UIColor(red: 247, green: 247, blue: 247).cgColor
        if let log = userDefaults.value(forKey: "isLogedIn") as? Bool{
            self.isLogedIn = log
        }
        
        if isLogedIn {
            self.loginBtn.setTitle("Logout", for: .normal)
        }

        
        let call_gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.OnCalll))
        let call_Taxi = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.OnCallTaxi))
        
        self.call_view.addGestureRecognizer(call_gesture)
        self.taxi_view.addGestureRecognizer(call_Taxi)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.cellImage.image = UIImage(named: "tab_prevcard3")
            cell.cellLabel.text = "About Privileb"
            break
        case 1:
            cell.cellImage.image = UIImage(named: "tab_home3")
            cell.cellLabel.text = "All deals"
            break
        case 2:
            cell.cellImage.image = UIImage(named: "tab_nearby3")
            cell.cellLabel.text = "Nearby me"
            break
        case 3:
            cell.cellImage.image = UIImage(named: "privileb_card3")
            cell.cellLabel.text = "Privileb card"
            break
        case 4:
            cell.cellImage.image = UIImage(named: "tab_categories3")
            cell.cellLabel.text = "Categories"
            break
        case 5:
            cell.cellImage.image = UIImage(named: "tab_favorite3")
            cell.cellLabel.text = "Favorites"
            break
        case 6:
            cell.cellImage.image = UIImage(named: "contact_us3")
            cell.cellLabel.text = "Contact us"
            break
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromReg {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "base")
            if #available(iOS 10.0, *) {
                AppDelegate.sharedDelegate().window?.rootViewController = controller
            } else {
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window!?.rootViewController = controller
            }
        }
        let rootController = UIApplication.shared.delegate?.window??.rootViewController as! MSSlidingPanelController
        let tab = (rootController.centerViewController as! CustomTabBarController)

        switch indexPath.row {
        case 0:
            tab.selectedIndex = 2
            (tab.viewControllers?[2] as! PrivilebCardController).onAbout(self)
            rootController.closePanel()
            break
        case 1:
            tab.selectedIndex = 2
            (tab.viewControllers?[2] as! PrivilebCardController).onAbout(self)
            rootController.closePanel()
            break
        case 2:
            tab.selectedIndex = 1
            rootController.closePanel()

            break
        case 3:
            tab.selectedIndex = 2
            rootController.closePanel()

            break
        case 4:
            tab.selectedIndex = 3
            rootController.closePanel()

            break
        case 5:
            tab.selectedIndex = 4
            rootController.closePanel()
            break
        case 6:
            tab.selectedIndex = 2
            (tab.viewControllers?[2] as! PrivilebCardController).onContact(self)
            rootController.closePanel()
            break
        default:
            print("")
        }
    }
    
    @IBAction func onCall(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Call hot line", message: "01697714", preferredStyle: .alert)
        let call = UIAlertAction(title: "Call", style: .default) { (alert) in
            if let url = NSURL(string: "tel://01697714") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(NSURL(string: "tel://01697714") as! URL)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(call)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func onCallCharli(_ sender: Any) {

        let alertController = UIAlertController(title: "Call Charlie Taxi", message: "1514", preferredStyle: .alert)
        let call = UIAlertAction(title: "Call", style: .default) { (alert) in
            if let url = NSURL(string: "tel://1514") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(NSURL(string: "tel://1514") as! URL)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(call)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.loginBtn.isEnabled = false
        
        if let log = userDefaults.value(forKey: "isLogedIn") as? Bool{
            self.isLogedIn = log
        }
        
        if isLogedIn {
            self.loginBtn.setTitle("Logout", for: .normal)
        }
        
        if  !isLogedIn{
            self.loginBtn.isEnabled = true
            if #available(iOS 10.0, *) {
                AppDelegate.sharedDelegate().openLogin()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNav")
                let rootController = UIApplication.shared.delegate?.window??.rootViewController as! MSSlidingPanelController
                rootController.centerViewController = controller
                rootController.closePanel()
            }
        }else{
            var service = services_calls()
            let uid = userDefaults.value(forKey: "userId") as! Int
            service.logout(user_id: uid.description, onComplete: { (res, status) in
                if status == "ok" {
                    if res?.status == 1 {
                        self.userDefaults.setValue(false, forKey: "isLogedIn")
                        self.userDefaults.setValue("", forKey: "userId")
                        self.userDefaults.setValue("", forKey: "countryId")
                        self.userDefaults.setValue("", forKey: "userMail")
                        self.userDefaults.setValue("", forKey: "userType")
                        self.loginBtn.setTitle("LogIn", for: .normal)
                        self.loginBtn.isEnabled = true
                    }else{
                        let alertController = UIAlertController(title: "Somthing went wrong!", message: res?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        self.loginBtn.isEnabled = true
                    }
                }else{
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.loginBtn.isEnabled = true
                }
            })
        }
    }
    @IBAction func onRegister(_ sender: Any) {
        if #available(iOS 10.0, *) {
            AppDelegate.sharedDelegate().openResgister()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "regNav")
            let rootController = UIApplication.shared.delegate?.window??.rootViewController as! MSSlidingPanelController
            rootController.centerViewController = controller
            rootController.closePanel()
        }
    }
    
    
    func OnCalll(){
        onCallCharli(self)
    }
    
    
    func OnCallTaxi() {
        onCall(self)
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
