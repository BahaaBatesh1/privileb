//
//  RegisterViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource , UIPickerViewDelegate , UIPickerViewDataSource {

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
    
    
    @IBOutlet weak var first_four: UITextField!
    
    
    @IBOutlet weak var second_four: UITextField!
    
    
    @IBOutlet weak var third_four: UITextField!
    
    
    @IBOutlet weak var fourth_four: UITextField!
    
    
    @IBOutlet weak var scroll: UIScrollView!
    
    var pickerView : UIPickerView!

    
       func slidingPanelController(_ panelController: MSSlidingPanelController!, beginsToBringOutSide side: MSSPSideDisplayed) {
        DispatchQueue.main.async {
            self.countryTextField.resignFirstResponder()

        }
        self.view.endEditing(true)

    }
    
    var birthDate :Date?
    var loader: MaterialLoadingIndicator!
    var selected_country : country!
    var isMale = false
    var isAgree = false
    var gender : String = "male"
    var countries = AppDelegate.sharedDelegate().countries
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.countryTextField.inputView = pickerView
        addKeyboardToolBar()
        
        
        
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
        scroll.keyboardDismissMode = .onDrag
    

        // Do any additional setup after loading the view.
    }
    
    
    func addKeyboardToolBar() {
        var nextButton: UIBarButtonItem?
        var keyboardToolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(pickerView.frame.size.width), height: CGFloat(25)))
        keyboardToolBar.sizeToFit()
        keyboardToolBar.barStyle = .default
        self.countryTextField.inputAccessoryView = keyboardToolBar
        nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        keyboardToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), nextButton!]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.countryTextField.resignFirstResponder()

    }
    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
        self.countryTextField.resignFirstResponder()
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
        scroll.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 40), animated: true)
        
        if textField.tag == 100{
            //textField.resignFirstResponder()
            self.birthdayView.isHidden = false
             scroll.setContentOffset(CGPoint(x: 0, y:  self.birthdayView.frame.origin.y), animated: true)
        }
        
        if textField.tag == 99{
            //textField.resignFirstResponder()
            //self.countries_view.isHidden = false
            scroll.setContentOffset(CGPoint(x: 0, y:  self.countries_view.frame.origin.y), animated: true)
        }

    }
    func donePicker(){
        if selected_country == nil {
            self.addressTextField.becomeFirstResponder()
            self.pickerView(self.pickerView, didSelectRow: 0, inComponent: 0)
        }
        
    self.countryTextField.text = selected_country.country_name
    self.countryTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//
//    }
    
    @IBAction func onRegister(_ sender: Any) {
        

   
            var allSerial = (self.first_four.text! + " " + self.second_four.text! + " " )
            allSerial = allSerial  + self.third_four.text! + " " + self.fourth_four.text!

            let services = services_calls()
            if(validation() && (allSerial.characters.count == 19)){
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected_country = countries[row]
        self.countryTextField.text = self.selected_country.country_name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row].country_name
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
        if(self.firstNameTextFiled.text == "" || self.addressTextField.text == ""  || self.birhDateTextField.text == "" || self.firstNameTextFiled.text == "" || self.lastNameTextField.text == "" || self.countryTextField.text == "" || self.confirmTextField.text == "" || self.mobileNumberTextFiled.text == "" || self.isAgree == false  || self.emailTextField.text == "" || self.passwordTextField.text == "" || self.first_four.text == "" || self.second_four.text == "" || self.third_four.text == "" || self.fourth_four.text == "" || !isValidEmail(testStr: self.emailTextField.text!)){
                return false
        }
        else {
            return true

        }
    
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.first_four {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4 // Bool
            
        }
        if textField == self.second_four {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4 // Bool
            
        }
        if textField == self.third_four {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4 // Bool
            
        }
        if textField == self.fourth_four {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4 // Bool
            
        }
        
        return true



    }
}
