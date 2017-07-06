//
//  PrivilebViewController.swift
//  Privileb
//
//  Created by SSS on 6/20/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class PrivilebViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let filterBtn = UIBarButtonItem(image: UIImage(named :"filter_mark2"), style: .plain, target: self, action: #selector(PrivilebViewController.onFilter(_:)))
        self.navigationItem.rightBarButtonItem = filterBtn
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false

    }
    @IBAction func onFilter(_ sender: AnyObject) {
        performSegue(withIdentifier: "filter", sender: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
