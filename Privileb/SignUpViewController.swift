//
//  SignUpViewController.swift
//  Privileb
//
//  Created by SSS on 6/20/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit
import Foundation
class SignUpViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var firstTime = true
    var services = services_calls()
    var loader: MaterialLoadingIndicator!
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor.white.cgColor
        self.loaderView.addSubview(loader)

        configureStyles()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if self.emailTextField.text != "" && self.phoneTextField.text != "" && self.nameTextField.text != "" {
            self.loader.startAnimating()
            self.loaderView.isHidden = false
            self.signupBtn.isEnabled = false

            services.add_to_news_letter(name: self.nameTextField.text!, email: self.emailTextField.text!, mobile_number: self.phoneTextField.text!, onComplete: { (res, status) in
                if status == "ok"{
                    if res?.status == 1 {
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        self.signupBtn.isEnabled = true
                        self.userDefaults.setValue(true, forKey: "isAddToNews")
                        self.onSkip(self)
                    }else{
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        self.signupBtn.isEnabled = true
                        let alertController = UIAlertController(title: "Failure!", message: res?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    self.signupBtn.isEnabled = true
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check you internet connection and try again!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func configureStyles()  {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        signupBtn.layer.cornerRadius = 3
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstTime{
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            firstTime = false
        }
    }
    
    func hideKeyboard() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        firstTime = true
    }

    @IBAction func onSkip(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "base")
        if #available(iOS 10.0, *) {
            AppDelegate.sharedDelegate().window?.rootViewController = controller
        } else {
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window!?.rootViewController = controller
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
    override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
    }

}
