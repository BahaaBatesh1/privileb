//
//  PartnerViewController.swift
//  Privileb
//
//  Created by ilove-apple.com on 7/8/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class PartnerViewController: UIViewController {
    @IBOutlet weak var patnerLogo: UIImageView!
    @IBOutlet weak var dealDetails: UITextView!
    @IBOutlet weak var firstNumber: UITextField!
    @IBOutlet weak var secondNumber: UITextField!
    @IBOutlet weak var thirdNumber: UITextField!
    @IBOutlet weak var fourthNumber: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
  scrollView.contentSize=CGSize(width: 414,height: 2300);
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
    

    @IBAction func onScanQR(_ sender: Any) {
    }
    
    @IBAction func onLogout(_ sender: Any) {
    }
    
    
    @IBOutlet weak var onBack: UIBarButtonItem!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
