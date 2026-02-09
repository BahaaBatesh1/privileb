//
//  PrivilebViewController.swift
//  Privileb
//
//  Created by SSS on 6/20/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class PrivilebViewController: BaseViewController {
    let Notification1 = Notification.Name(rawValue:"fillOffers")
    var filterBtn :UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBtn = UIBarButtonItem(image: UIImage(named :"filter_mark2"), style: .plain, target: self, action: #selector(PrivilebViewController.onFilter(_:)))
        self.navigationItem.rightBarButtonItem = filterBtn
        filterBtn.isEnabled = false
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification1, object:nil, queue:nil, using:onFinishLoad)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "fillOffers"), object: nil);
    }
    @IBAction func onFilter(_ sender: AnyObject) {
        performSegue(withIdentifier: "filter", sender: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func onFinishLoad(notification:Notification)  {
        DispatchQueue.main.async {
            self.filterBtn.isEnabled = true
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
