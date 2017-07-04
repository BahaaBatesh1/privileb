//
//  RegisterViewController.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController ,UITextFieldDelegate{

    @IBOutlet weak var birhDateTextField: GrayTextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var birthdayView: UIView!
    var birthDate :Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
