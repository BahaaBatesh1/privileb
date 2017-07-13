//
//  BuyCardViewController.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/8/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class BuyCardViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var comments: UITextField!
    
    @IBOutlet weak var firstRadio: UIButton!
    
    @IBOutlet weak var secondRadio: UIButton!
    var loader: MaterialLoadingIndicator!

    var order_method_id : String!
    
    var lastTagField = 0
    
    var shouldScroll = true
    
    @IBOutlet weak var loaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuyCardViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)

        scrollView.contentSize=CGSize(width: 414,height: 2300);
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor.white.cgColor
        self.loaderView.addSubview(loader)


        firstRadio.layer.cornerRadius = firstRadio.layer.frame.width / 2
        firstRadio.layer.borderColor = UIColor.lightGray.cgColor
        firstRadio.layer.borderWidth = 1
        firstRadio.backgroundColor = UIColor.white
        
        secondRadio.layer.cornerRadius = secondRadio.layer.frame.width / 2
        secondRadio.layer.borderColor = UIColor.lightGray.cgColor
        secondRadio.layer.borderWidth = 1
        secondRadio.backgroundColor = UIColor.white

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onFirstRadio(_ sender: Any) {
        firstRadio.backgroundColor = UIColor.gray
        secondRadio.backgroundColor = UIColor.white

        
    }
    @IBAction func onSecondRadio(_ sender: Any) {
        secondRadio.backgroundColor = UIColor.gray
        firstRadio.backgroundColor = UIColor.white
    }

    @IBAction func onActivate(_ sender: Any) {
        shouldScroll = false
        let service = services_calls()
        
        if self.self.firstName.text != "" && self.address.text != "" && self.email.text != "" && self.lastName.text != "" && self.comments.text != "" && self.mobileNumber.text != ""{
            loader.startAnimating()
            self.loaderView.isHidden = false
            service.buy_card(fname: self.firstName.text!, lname: self.lastName.text!, email: self.email.text!, mobile_number: self.mobileNumber.text!, address: self.address.text!,comments : self.comments.text!, payment_method_id: "1", order_status_id: "1", datetime: NSDate().getToDay()) { (res, status) in
                if status == "ok"{
                    if res?.status == 1 {
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        let alertController = UIAlertController(title: "Success!", message: res?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        self.shouldScroll = true
                    }else{
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        let alertController = UIAlertController(title: "Somthing went wrong!", message: res?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        self.shouldScroll = true
                    }
                }else{
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                    self.shouldScroll = true

                }
                
            }
            
        }else{
            let alertController = UIAlertController(title: "Empty fields!", message: "Please fill all fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            self.shouldScroll = true
        }
        
      
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.address.resignFirstResponder()
        self.comments.resignFirstResponder()
        self.email.resignFirstResponder()
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.mobileNumber.resignFirstResponder()
        view.endEditing(true)
    }
    
    func hideKeyboard() {
        if shouldScroll{
        self.address.resignFirstResponder()
        self.comments.resignFirstResponder()
        self.email.resignFirstResponder()
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.mobileNumber.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
