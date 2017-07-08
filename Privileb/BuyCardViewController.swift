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
    
    var lastTagField = 0
    var call : services_calls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuyCardViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)

        call = services_calls()
        scrollView.contentSize=CGSize(width: 414,height: 2300);


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onFirstRadio(_ sender: Any) {
    }
    @IBAction func onSecondRadio(_ sender: Any) {
    }

    @IBAction func onActivate(_ sender: Any) {
        
        
        call?.buy_card(fname: self.firstName.text!, lname: self.lastName.text!, email: self.email.text!, mobile_number: self.mobileNumber.text!, address: self.address.text!, payment_method_id: "", order_status_id: "", datetime: NSDate().getToDay())
        
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
        self.address.resignFirstResponder()
        self.comments.resignFirstResponder()
        self.email.resignFirstResponder()
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.mobileNumber.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
