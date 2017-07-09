//
//  PartnerViewController.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/8/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class PartnerViewController: UIViewController ,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var chooseDealTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var patnerLogo: UIImageView!

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var dealDetails: UITextField!
    
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var secondNumber: UITextField!
    @IBOutlet weak var thirdNumber: UITextField!
    @IBOutlet weak var fourthNumber: UITextField!
    let userDefaults = UserDefaults.standard
    var isTableShow = false
    var deals:[String] = ["sad","asdas","asdasdadasdasdas"]
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableImage: UIImageView!
    
    var loader: MaterialLoadingIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize=CGSize(width: 414,height: 2300)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuyCardViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        self.loaderView.addSubview(loader)

//        self.firstNumber.input
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
       
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partnerDeal")
        cell?.textLabel?.text = self.deals[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseDealTextField.text = self.deals[indexPath.row]
        self.tableView.isHidden = true
        self.tableImage.image = UIImage(named:"SortD")
    }
    @IBAction func onScanQR(_ sender: Any) {
        performSegue(withIdentifier: "toScan", sender: self)
    }
    
    @IBAction func onLogout(_ sender: Any) {
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
                    self.userDefaults.setValue("", forKey: "retailerId")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "signUp")
                    if #available(iOS 10.0, *) {
                        AppDelegate.sharedDelegate().window?.rootViewController = controller
                    } else {
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window!?.rootViewController = controller
                    }
                }else{
                    let alertController = UIAlertController(title: "Somthing went wrong!", message: res?.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.chooseDealTextField{
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 1000 // Bool

        }else if textField == self.dealDetails{
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 1000 // Bool

        }else{
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 1 // Bool
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.firstNumber.resignFirstResponder()
        self.secondNumber.resignFirstResponder()
        self.thirdNumber.resignFirstResponder()
        self.fourthNumber.resignFirstResponder()
        self.dealDetails.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField == self.dealDetails{
        
        }else{
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
    }
    func hideKeyboard() {
        self.firstNumber.resignFirstResponder()
        self.secondNumber.resignFirstResponder()
        self.thirdNumber.resignFirstResponder()
        self.fourthNumber.resignFirstResponder()
        self.dealDetails.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag < 4 {
            textField.resignFirstResponder()
            self.view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        }else{
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onChoosDealsBtn(_ sender: Any) {
        if isTableShow{
            self.tableImage.image = UIImage(named:"SortD")
            self.tableView.isHidden = true
            self.tableView.reloadData()
        }else{
            self.tableImage.image = UIImage(named:"SortU")
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func callScan() {
        var service = services_calls()
        loader.startAnimating()
        self.loaderView.isHidden = false

        service.scan_offer(user_id: "", scan_date: NSDate().getToDay(), offer_id: "", branch_id: "", serial_number: "") { (res, status) in
            if status == "ok" {
                if res?.status == 1 {
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true

                }else{
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    let alertController = UIAlertController(title: "Failure!", message: res?.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
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
