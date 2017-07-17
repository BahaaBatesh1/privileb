//
//  AppDelegate.swift
//  Privileb
//
//  Created by SSS on 6/20/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var displayDic : [Int:CatDisplay] = [:]
    var categories : [categoryy] = []
    let services = services_calls()
    var selectedCell :Int = 0
    var desricts :[district] = []
    var countries : [country] = []
    var about:static_page?
    var binifits:static_page?
    var terms:static_page?
    var joinOur:static_page?
    var charity:static_page?
    var card :card?
    var selectedCat : [categoryy] = []
    var selectedDis : [district] = []

    var unSelectedCat : [categoryy] = []
    var unSelectedDis : [district] = []
    
    var current_user : user?

    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if let isLogiedIn = self.userDefaults.value(forKey: "isLogedIn") as? Bool {
            if isLogiedIn {
                if let type = userDefaults.value(forKey: "userType") as? String {
                    if type == "Cardholder" {
                        loadCard()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "signUp")
                        if #available(iOS 10.0, *) {
                            AppDelegate.sharedDelegate().window?.rootViewController = controller
                        } else {
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window!?.rootViewController = controller
                        }
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "QR")
                        if #available(iOS 10.0, *) {
                            AppDelegate.sharedDelegate().window?.rootViewController = controller
                        } else {
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window!?.rootViewController = controller
                        }
                    }
                }
            }
        }
        
        
        
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(red: 30, green: 30, blue: 30)
        navigationBarAppearace.setBackgroundImage(UIImage(),for:.default)
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.backgroundColor = UIColor(red: 30, green: 30, blue: 30)
        navigationBarAppearace.isTranslucent = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 9)]
        appearance.setTitleTextAttributes(attributes, for: .normal)

        //load categories
        services.get_categories(country_code: "lb") { (categories, status,postRes) in
            if status == "ok" {
                self.categories = categories!
                self.unSelectedCat = categories!
                DispatchQueue.main.async {
                    self.fillDic()
                }
            }
        }
        
        //laod countries
        services.get_countries { (cos, status,postRes) in
            if status == "ok" {
                self.countries = cos!
            }
        }
        
        //load district
        services.get_districts(country_code: "lb") { (des, status,postRes) in
            if status  == "ok"{
                self.desricts = des!
                self.unSelectedDis = des!
            }
        }
        
        //load static pages
        services.get_static_page(country_code: "lb") { (pages, status,postRes) in
            if status == "ok" {
                self.fillStatitcPages(pages: pages!)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Actions
    func openResgister() {
        openControllerWithIndentifier(identifier: "regNav")
    }
    
    func openLogin() {
        openControllerWithIndentifier(identifier: "loginNav")
    }
    
    func openNerby() {
        openControllerWithIndentifier(identifier: "nerNav")
    }
    
    func openCtegories() {
        openControllerWithIndentifier(identifier: "catNav")
    }
    
    func openPrevCard() {
        openControllerWithIndentifier(identifier: "prevCard")
    }
    func openPrevlib() {
        openControllerWithIndentifier(identifier: "prevNav")
    }
    func openFavorite() {
        openControllerWithIndentifier(identifier: "favNav")
    }
    func openCharities() {
        openControllerWithIndentifier(identifier: "chNav")
    }
    // MARK: - Private Methods
    private func openControllerWithIndentifier(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        let rootController = window?.rootViewController as! MSSlidingPanelController
        
        rootController.centerViewController = controller
        rootController.closePanel()
    }

    func fillDic()  {
        self.displayDic.removeAll()
        for category in categories{
            let c = CatDisplay()
            c.load_aimage(urlString: category.icon_active)
            c.load_Mimage(urlString: category.image)
            c.load_Inimage(urlString: category.icon_inactive)
            c.name = category.name
            self.displayDic.updateValue(c, forKey: category.category_id)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLoadCategories"), object: nil)

    }
    
    func fillStatitcPages(pages:[static_page]) {
        for page in pages {
            if page.id == 1{//about
                self.about = page
            }else if page.id == 3{//terms
                self.terms = page
            }else if page.id == 4 {//benefit
                self.binifits = page
            }else if page.id == 5{//our family
                self.joinOur = page
            }else if page.id == 7 {
                self.charity = page
            }
        }
    }
    
    func set_current_user (user : user){
        self.current_user = user
    }
    func get_current_user () ->user {
        
        return self.current_user!
    
    }
    
    func loadCard() {
        if let isLogiedIn = self.userDefaults.value(forKey: "isLogedIn") as? Bool {
            if isLogiedIn {
                if let uid = self.userDefaults.value(forKey: "userId") as? Int{
                    services.get_card(user_id: uid.description, onComplete: { (card, status, res) in
                        if status == "ok" {
                            if res?.status == 1 {
                                self.card = card
                            }
                        }
                    })
                }
            }
        }
    }
}

