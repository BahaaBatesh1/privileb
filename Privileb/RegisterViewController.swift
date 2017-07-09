//
//  RegisterViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate{

    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var agressBtn: UIButton!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextFiled: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextFiled: UITextField!
    @IBOutlet weak var verfyCodeTextFiled: UITextField!
    @IBOutlet weak var searialTextField: UITextField!
    @IBOutlet weak var birhDateTextField: GrayTextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var birthdayView: UIView!
    var birthDate :Date?
    var loader: MaterialLoadingIndicator!

    var isMale = false
    var isAgree = false
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = true
        self.maleBtn.layer.cornerRadius = self.maleBtn.layer.frame.width / 2
        self.maleBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.maleBtn.layer.borderWidth = 1
        self.maleBtn.backgroundColor = UIColor.white
        
        self.femaleBtn.layer.cornerRadius = self.femaleBtn.layer.frame.width / 2
        self.femaleBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.femaleBtn.layer.borderWidth = 1
        self.femaleBtn.backgroundColor = UIColor.white

        self.agressBtn.layer.borderWidth = 1
        self.agressBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor.white.cgColor
        self.loaderView.addSubview(loader)

        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        birthdayView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    
    @IBAction func onBirthdayBtn(_ sender: Any) {
        self.birthdayView.isHidden = false
    }
    @IBAction func onChooseBirthDay(_ sender: Any) {
        self.birthDate = birthdayPicker.date
        self.birthdayView.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter.string(from: self.birthDate!)
        self.birhDateTextField.text = date1
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 100{
            textField.resignFirstResponder()
            self.birthdayView.isHidden = false
        }
    }
    
    @IBAction func onRegister(_ sender: Any) {
        var services = services_calls()
        
        self.loader.startAnimating()
        self.loaderView.isHidden = false

        services.register(datetime: NSDate().getToDay(), fname: firstNameTextFiled.text!, lname: lastNameTextField.text!, serial_number: self.searialTextField.text!, birthdate: birhDateTextField.text!, gender: "male", country_id: self.countryTextField.text!, email: emailTextField.text!, mobile_number: mobileNumberTextFiled.text!, password: passwordTextField.text!) { (res, status) in
            
            if status == "ok" {
                if res?.status == 1 {
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true

                }else{
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    let alertController = UIAlertController(title: "Failure", message: res?.message, preferredStyle: .alert)
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
    
    @IBAction func onAgreeBtn(_ sender: Any) {
        if isAgree{
            self.isAgree = false
            self.agressBtn.backgroundColor = UIColor.white
        }else{
            self.isAgree = true
            self.agressBtn.backgroundColor = UIColor.gray
        }
    }
    @IBAction func onFemale(_ sender: Any) {
        self.isMale = false
        self.femaleBtn.backgroundColor = UIColor.gray
        self.maleBtn.backgroundColor = UIColor.white
    }
    @IBAction func onMale(_ sender: Any) {
        self.isMale = true
        self.femaleBtn.backgroundColor = UIColor.white
        self.maleBtn.backgroundColor = UIColor.gray
    }
    
    func hideKeyboard()  {
        self.birthdayView.isHidden = true
        self.birhDateTextField.resignFirstResponder()
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
