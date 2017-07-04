//
//  LoginViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController ,UITextFieldDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgetTextField: GrayTextField!
    @IBOutlet weak var forgetView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    var services = services_calls()
    var user:user?
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self

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
        services.forgot_password(email: self.forgetTextField.text!) { (res, status) in
            if status == "ok" {
                if res?.status == 1 {
                    print("success")
                    self.forgetView.isHidden = true
                }
            }else{
                print("error service")
                self.forgetView.isHidden = true
            }
        }
    }
    @IBAction func onLogin(_ sender: Any) {
        services.login(email: userNameTextField.text!, password: passwordTextField.text!) { (user, status) in
            if status == "ok"{
                self.user = user
            }else{
                print("error")
            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
