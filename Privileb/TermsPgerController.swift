//
//  TermsPgerController.swift
//  Privileb
//
//  Created by SSS on 6/27/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

protocol TermsPagerProtocol{
    func didChangeTab(position: Int)
}
class TermsPgerController:  PagerController, PagerDataSource, PagerDelegate {
    var tabChangedDelegate : TermsPagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        self.tabHeight = 40
        self.indicatorHeight = 2
        self.tabWidth = UIScreen.main.bounds.size.width / 2
        self.indicatorColor = UIColor(red: 212, green: 172, blue: 92)
        self.tabsViewBackgroundColor = UIColor(red: 30, green: 30, blue: 30)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfTabs(pager: PagerController) -> Int {
        return 2
    }
    
    func tabViewForIndex(index: Int, pager: PagerController) -> UIView {
        let label = UILabel();
        label.font = UIFont(name: label.font.fontName, size: 14)
        label.textColor = UIColor.white
        
        if(index == 0){
            label.text = "English"
            label.tag = 0
        } else {
            label.text = "عربي"
            label.tag = 1
        }
        label.sizeToFit()
        
        return label
    }
    
    func controllerForTabAtIndex(index: Int, pager: PagerController) -> UIViewController {
        if(index == 0){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "englishTerms") as! EnglishTermsViewController
            return controller
            
        } else {
            //Walks
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "arabicTerms") as! ArabicTermsViewController
            return controller
            
        }
        
    }
    
    func didChangeTabToIndex(pager: PagerController, index: Int) {
        self.tabChangedDelegate?.didChangeTab(position: index)
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
