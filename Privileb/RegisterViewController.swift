//
//  RegisterViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var coutries_table: UITableView!
    @IBOutlet weak var countries_view: UIView!
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
    var selected_country : country!
    var isMale = false
    var isAgree = false
    var gender : String = "male"
    var countries = AppDelegate.sharedDelegate().countries
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

        countries_view.layer.cornerRadius = 3
        countries_view.layer.backgroundColor = UIColor.lightGray.cgColor
        countries_view.layer.borderWidth = 1
        
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
        
        if textField.tag == 99{
            textField.resignFirstResponder()
            self.countries_view.isHidden = false
        }

    }
    
    @IBAction func onRegister(_ sender: Any) {
        

        if self.searialTextField.text?.characters.count != 16 {
            let alertController = UIAlertController(title: "Information Error", message: "Please check Serial number!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let allSerial : NSMutableString = NSMutableString(string:self.searialTextField.text!)
            allSerial.insert(" ", at: 4)
            allSerial.insert(" ", at: 9)
            allSerial.insert(" ", at: 14)

            let services = services_calls()
            if(validation()){
                self.loader.startAnimating()
                self.loaderView.isHidden = false
                
                services.register(datetime: NSDate().getToDay(), fname: firstNameTextFiled.text!, lname: lastNameTextField.text!, serial_number: allSerial as String, birthdate: birhDateTextField.text!, gender: self.gender, country_id: self.selected_country.country_id.description, email: emailTextField.text!, mobile_number: mobileNumberTextFiled.text!, password: passwordTextField.text! , address : self.addressTextField.text!) { (res, status) in
                    
                    if status == "ok" {
                        if res?.status == 1 {
                            self.loader.stopAnimating()
                            self.loaderView.isHidden = true
                            
                            let alertController = UIAlertController(title: "Succeeded please login with your new info", message: res?.message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                            
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
                
            else {
                
                let alertController = UIAlertController(title: "Information Error", message: "Please check all of your information in fields", preferredStyle: .alert)
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
        self.gender = "female"
        self.isMale = false
        self.femaleBtn.backgroundColor = UIColor.gray
        self.maleBtn.backgroundColor = UIColor.white
    }
    @IBAction func onMale(_ sender: Any) {
        self.gender = "male"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_country = self.countries[indexPath.row]
        self.countryTextField.text = self.countries[indexPath.row].country_name
        self.countries_view.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country_cell")
        cell?.textLabel?.text = self.countries[indexPath.row].country_name
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func validation () -> Bool {
        if(self.firstNameTextFiled.text == "" || self.addressTextField.text == ""  || self.birhDateTextField.text == "" || self.firstNameTextFiled.text == "" || self.lastNameTextField.text == "" || self.countryTextField.text == "" || self.confirmTextField.text == "" || self.mobileNumberTextFiled.text == "" || self.isAgree == false  || self.emailTextField.text == "" || self.passwordTextField.text == ""){
                return false
        }
        else {
            return true

        }
    
    }

}
