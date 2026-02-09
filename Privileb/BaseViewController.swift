//
//  BaseViewController.swift
//  Restaurant
//
//  Created by AppsFoundation on 8/27/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,MSSlidingPanelControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slidingPanelController.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "row-reorder")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onMenu(_:)))
    }
    
    // MARK: - Actions
     @IBAction func onMenu(_ sender: AnyObject) {
        if slidingPanelController.sideDisplayed == MSSPSideDisplayed.left {
            slidingPanelController.closePanel()
        } else {
            slidingPanelController.openLeftPanel()
        }
    }
    
    func slidingPanelController(_ panelController: MSSlidingPanelController!, hasOpenedSide side: MSSPSideDisplayed) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"color_menu")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onMenu(_:)))
    }
    func slidingPanelController(_ panelController: MSSlidingPanelController!, hasClosedSide side: MSSPSideDisplayed) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"row-reorder")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onMenu(_:)))
        
    }
}
