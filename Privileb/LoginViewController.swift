//
//  LoginViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController ,UITextFieldDelegate{

    @IBOutlet weak var laoderViewMail: UIView!
    @IBOutlet weak var keepMeLogedInBtn: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgetTextField: GrayTextField!
    @IBOutlet weak var forgetView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    var loader: MaterialLoadingIndicator!
    var loaderMail: MaterialLoadingIndicator!
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var services = services_calls()
    var user:user?
    var firstTime = true
    var keepMe = false
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self

        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor.white.cgColor
        self.loaderView.addSubview(loader)

        loaderMail = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        loaderMail.center = CGPoint(x: self.laoderViewMail.frame.width/2, y: self.laoderViewMail.frame.height/2)
        loaderMail.circleShapeLayer.strokeColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        self.laoderViewMail.addSubview(loaderMail)

        
        loginBtn.layer.cornerRadius = 3
        
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: navigationBar.frame.width/2 - 35, y: navigationBar.frame.height / 2 - 12.5 , width: 25, height: 25)
            let secondFrame = CGRect(x: navigationBar.frame.width/2, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
            let imageView = UIImageView(frame: firstFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "login")
            let secondLabel = UILabel(frame: secondFrame)
            secondLabel.textColor = UIColor.white
            secondLabel.font.withSize(20)
            secondLabel.text = "LOG IN"
            navigationBar.addSubview(imageView)
            navigationBar.addSubview(secondLabel)
        }
        
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDontHaveAccount(_ sender: Any) {
    }
    @IBAction func onForgotPassword(_ sender: Any) {
        self.forgetView.isHidden = false
    }

    @IBAction func onSendForget(_ sender: Any) {
        self.forgetTextField.resignFirstResponder()
        self.laoderViewMail.isHidden = false
        self.loaderMail.startAnimating()
        if self.forgetTextField.text != "" {
            services.forgot_password(email: self.forgetTextField.text!) { (res, status) in
                if status == "ok" {
                    if res?.status == 1 {
                        self.laoderViewMail.isHidden = true
                        self.loaderMail.stopAnimating()
                        self.forgetView.isHidden = true
                        let alertController = UIAlertController(title: "Email sent successfully!", message: "Please check your email!", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        self.laoderViewMail.isHidden = true
                        self.loaderMail.stopAnimating()
                        self.forgetView.isHidden = true
                        let alertController = UIAlertController(title: "Failure!", message: res?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.laoderViewMail.isHidden = true
                    self.loaderMail.stopAnimating()
                    self.forgetView.isHidden = true
                    let alertController = UIAlertController(title: "Failure!", message: res?.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.forgetView.isHidden = true
                }
            }
        }
    }
    @IBAction func onLogin(_ sender: Any) {
        loginBtn.isEnabled = false
        if self.userNameTextField.text != "" && self.passwordTextField.text != "" {
            loader.startAnimating()
            self.loaderView.isHidden = false

            services.login(email: userNameTextField.text!, password: passwordTextField.text!) { (user, status,postRes) in
                if status == "ok"{
                    if user?.response.status == 1 {
                        if user?.type == "Cardholder"{
                            self.loginBtn.isEnabled = true
                            self.loader.stopAnimating()
                            self.loaderView.isHidden = true
                            self.user = user
                            self.userDefaults.setValue(true, forKey: "isLogedIn")
                            self.userDefaults.setValue(user?.id, forKey: "userId")
                            self.userDefaults.setValue(user?.country_id, forKey: "countryId")
                            self.userDefaults.setValue(user?.email, forKey: "userMail")
                            self.userDefaults.setValue(user?.type, forKey: "userType")
                            self.userDefaults.setValue(user?.fname, forKey: "userName")

                            AppDelegate.sharedDelegate().loadCard()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "base")
                            if #available(iOS 10.0, *) {
                                AppDelegate.sharedDelegate().window?.rootViewController = controller
                            } else {
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window!?.rootViewController = controller
                            }
                        }else{
                            self.loginBtn.isEnabled = true
                            self.loader.stopAnimating()
                            self.loaderView.isHidden = true
                            self.user = user
                            self.userDefaults.setValue(true, forKey: "isLogedIn")
                            self.userDefaults.setValue(user?.id, forKey: "userId")
                            self.userDefaults.setValue(user?.country_id, forKey: "countryId")
                            self.userDefaults.setValue(user?.email, forKey: "userMail")
                            self.userDefaults.setValue(user?.type, forKey: "userType")
                            self.userDefaults.setValue(user?.fname, forKey: "userName")
                            self.userDefaults.setValue(user?.retailer_id, forKey: "retailerId")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "QR")
                            if #available(iOS 10.0, *) {
                                AppDelegate.sharedDelegate().window?.rootViewController = controller
                            } else {
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window!?.rootViewController = controller
                            }

                        }
                    }else{
                        self.loginBtn.isEnabled = true
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        let alertController = UIAlertController(title: "Somthing went wrong!", message: user?.response?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.loginBtn.isEnabled = true
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    print("error")
                }
            }
        }else{
            self.loginBtn.isEnabled = true
            let alertController = UIAlertController(title: "Empty fields!", message: "Please enter email and password!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        forgetTextField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstTime{
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            firstTime = false
        }
    }
    
    func hideKeyboard() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        forgetTextField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        firstTime = true
    }
    
    @IBAction func onkeepMe(_ sender: Any) {
        if keepMe {
            (sender as! UIButton).backgroundColor = UIColor.white
            keepMe = false
        }else{
            (sender as! UIButton).backgroundColor = UIColor.gray
            keepMe = true
        }
    }
    @IBAction func onCanceMail(_ sender: Any) {
        self.forgetView.isHidden = true
        self.loaderMail.stopAnimating()
        self.laoderViewMail.isHidden = false
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
