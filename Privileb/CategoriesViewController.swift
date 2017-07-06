//
//  ThirdViewController.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var mainImage: UIImageView!
    var displayDic : [Int:CatDisplay] = [:]
    var selectedTags : [categoryy] = []
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    let services = services_calls()
    var categories : [categoryy] = []
    let Notification1 = Notification.Name(rawValue:"finishLoadCategories")

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.slidingPanelController.leftPanelController as! MenuViewController).isFromReg = false

        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification1, object:nil, queue:nil, using:onFinishLoad)


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.displayDic = AppDelegate.sharedDelegate().displayDic
        self.categories = AppDelegate.sharedDelegate().categories
        self.categoriesCollectionView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "finishLoadCategories"), object: nil);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView{
            return categories.count
        }else{
            return selectedTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as! CategoryCollectionViewCell
            let id = self.categories[indexPath.row].category_id
            if (self.displayDic[id!]?.isSelected)! {
                cell.categoryImage.image = self.displayDic[id!]?.activeImage
            }else{
                cell.categoryImage.image = self.displayDic[id!]?.inActiveImage
            }
            cell.categoryLabel.text = self.displayDic[id!]?.name
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCollectionViewCell
            cell.tagLable.text = " " + selectedTags[indexPath.row].name + " "
            cell.tagLable.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
            cell.tagLable.sizeToFit()
            return cell
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = (collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell)
//        return CGSize(width: cell.tagLable.frame.width, height: cell.frame.height)
//    }
//
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = categories[indexPath.row].category_id
        if (self.displayDic[id!]?.isSelected)!{
            Remove(cat_id: id!)
            self.displayDic[id!]?.isSelected = false
        }else{
            selectedTags.append(categories[indexPath.row])
            self.displayDic[id!]?.isSelected = true
        }
        self.mainImage.image = self.displayDic[id!]?.mainImage
        self.tagsCollectionView.reloadData()
        self.categoriesCollectionView.reloadData()
    }
    
    func onFinishLoad(notification:Notification)  {
        self.displayDic = AppDelegate.sharedDelegate().displayDic
        self.categories = AppDelegate.sharedDelegate().categories

        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }
    }
    
    func Remove(cat_id:Int) {
        var i = 0
        for cat in selectedTags {
            if cat.category_id == cat_id{
              selectedTags.remove(at: i)
            }
            i = i + 1
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
