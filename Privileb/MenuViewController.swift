//
//  MenuViewController.swift
//  Privileb
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var login_image: UIImageView!
    @IBOutlet weak var registerImage: UIImageView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
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
            if let name = userDefaults.value(forKey: "userName") as? String{
                self.registerBtn.isHidden = true
                self.registerImage.isHidden = true
                self.registerLabel.isHidden = false
                self.registerLabel.text = "Welcome \(name)"
            }
            self.loginBtn.setTitle("Logout", for: .normal)
        }else{
            self.registerBtn.isHidden = false
            self.registerImage.isHidden = false
            self.registerLabel.isHidden = true
            self.registerLabel.text = ""
        }

        
        let call_gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.OnCalll))
        let call_Taxi = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.OnCallTaxi))
        
        self.call_view.addGestureRecognizer(call_gesture)
        self.taxi_view.addGestureRecognizer(call_Taxi)
        
        
        
        let login_gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.onlog))
        let register_gesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.onreg))
        
        
        self.login_image.addGestureRecognizer(login_gesture)
        self.registerImage.addGestureRecognizer(register_gesture)
        

        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLogedIn ? 9 : 8
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
            cell.cellLabel.text = "Nearby"
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
            cell.cellImage.image = UIImage(named: "charityx3")
            cell.cellLabel.text = "Charities"
            break
        case 7:
            cell.cellImage.image = UIImage(named: "contact_us3")
            cell.cellLabel.text = "Contact us"
            break
        case 8:
            cell.cellLabel.text = "Delete account"
        default:
            break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image = (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image?.withRenderingMode(.alwaysTemplate)
        (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.tintColor = UIColor.black
   
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
            tab.selectedIndex = 0
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
            if #available(iOS 10.0, *) {
                AppDelegate.sharedDelegate().openCharities()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "chNav")
                let rootController = UIApplication.shared.delegate?.window??.rootViewController as! MSSlidingPanelController
                rootController.centerViewController = controller
                rootController.closePanel()
            }
            break
        case 7:
            tab.selectedIndex = 2
            (tab.viewControllers?[2] as! PrivilebCardController).onContact(self)
            rootController.closePanel()
            break
            
        case 8:
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                self.deleteAccount()
            })
            alertController.addAction(cancel)
            alertController.addAction(confirm)
            self.present(alertController, animated: true, completion: nil)
        default:
            print("")
        }
        
        
        (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image = (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image?.withRenderingMode(.alwaysOriginal)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image = (tableView.cellForRow(at: indexPath)as! MenuTableViewCell).cellImage.image?.withRenderingMode(.alwaysOriginal)
    }
    
    
    @IBAction func onCall(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Call hotline", message: "81717272", preferredStyle: .alert)
        let call = UIAlertAction(title: "Call", style: .default) { (alert) in
            if let url = NSURL(string: "tel://81717272") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: ["":""], completionHandler: nil)
                } else {
                    _ = UIApplication.shared.openURL(NSURL(string: "tel://81717272") as! URL)
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
                        self.isLogedIn = false
                        self.userDefaults.setValue(false, forKey: "isLogedIn")
                        self.userDefaults.setValue("", forKey: "userId")
                        self.userDefaults.setValue("", forKey: "countryId")
                        self.userDefaults.setValue("", forKey: "userMail")
                        self.userDefaults.setValue("", forKey: "userType")
                        self.userDefaults.setValue("", forKey: "userName")
//                        self.userDefaults.setValue("", forKey: "branch_id")

                        self.registerBtn.isHidden = false
                        self.registerImage.isHidden = false
                        self.registerLabel.isHidden = true
                        self.registerLabel.text = ""
                        self.loginBtn.setTitle("LogIn", for: .normal)
                        self.loginBtn.isEnabled = true
                        self.tableView.reloadData()
                        
                    }else{
                        let alertController = UIAlertController(title: "Something went wrong!", message: res?.message, preferredStyle: .alert)
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
    
    
    @objc func OnCalll(){
        onCallCharli(self)
    }
    
    
    @objc func OnCallTaxi() {
        onCall(self)
        }
    
    
    @objc func onlog(){
        onLogin(self);
    }
    
    @objc func onreg(){
        onRegister(self);
    }
    
    func deleteAccount() {
        var service = services_calls()
        service.deleteAccount(onComplete: { (res, status) in
            if status == "ok" {
                if res?.status == 1 {
                    self.isLogedIn = false
                    self.userDefaults.setValue(false, forKey: "isLogedIn")
                    self.userDefaults.setValue("", forKey: "userId")
                    self.userDefaults.setValue("", forKey: "countryId")
                    self.userDefaults.setValue("", forKey: "userMail")
                    self.userDefaults.setValue("", forKey: "userType")
                    self.userDefaults.setValue("", forKey: "userName")
//                    self.userDefaults.setValue("", forKey: "branch_id")
                    
                    self.registerBtn.isHidden = false
                    self.registerImage.isHidden = false
                    self.registerLabel.isHidden = true
                    self.registerLabel.text = ""
                    self.loginBtn.setTitle("LogIn", for: .normal)
                    self.loginBtn.isEnabled = true
                    
                    let alertController = UIAlertController(title: "Email sent", message: "We've sent you an email to proceed with deleting your account.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.tableView.reloadData()
                    
                } else {
                    let alertController = UIAlertController(title: "Something went wrong!", message: res?.message, preferredStyle: .alert)
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
            }
        })
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
