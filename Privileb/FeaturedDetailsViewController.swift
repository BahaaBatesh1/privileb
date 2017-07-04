//
//  FeaturedDetailsViewController.swift
//  customTab
//
//  Created by SSS on 6/21/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FeaturedDetailsViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var favoritBtnRight: UIButton!
    @IBOutlet weak var supervisedImage: UIImageView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var cateoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var offerId :Int?
    let services = services_calls()
    var detailedOffer : offer_details!
    var loader: MaterialLoadingIndicator!
    var offerImages:[String] = []
    @IBOutlet weak var validatyValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize=CGSize(width: 320,height: 2100);
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        self.loaderView.addSubview(loader)

        // if not favorite
        favoritBtnRight.setImage(UIImage(named: "offer_favorite3"), for: .normal)
        
        loader.startAnimating()
        self.loaderView.isHidden = false
        services.get_offer_details(offer_id: "\(self.offerId!)") { (offerD, status) in
            if status == "ok"{
                DispatchQueue.main.async {
                    self.detailedOffer = offerD
                    
                    var subCat = ""
                    var i = 0
                    for cat in (self.detailedOffer?.sub_categories)!{
                        if i == (self.detailedOffer?.sub_categories.count)! - 1 {
                            subCat.append(cat.name)
                        }else{
                            subCat = subCat + cat.name + " & "
                        }
                        i = i + 1
                    }
                    self.cateoryLabel.text = subCat
                    self.dateLabel.text = "From \(self.detailedOffer.issue_date!) To \(self.detailedOffer.expiry_date!)"
                    self.descriptionLabel.text = "Description: \(self.detailedOffer.description!)"
                    self.frequencyLabel.text = "Frequency: \(self.detailedOffer.frequency!)"
                    self.offerImages = self.detailedOffer.gallery_cropped!
                    self.offerLabel.text = self.detailedOffer.offer_name
                    self.load_image(urlString: (self.detailedOffer.retailer_logo)!, imageView: self.supervisedImage)
                    self.validatyValueLabel.text = self.detailedOffer.validity
                    self.loader.stopAnimating()
                    self.loaderView.isHidden = true
                    self.imagesCollectionView.reloadData()
                }

            }else{
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                print("error")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.loader.stopAnimating()
        self.loaderView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
       _ =  self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }


    @IBAction func onShare(_ sender: Any) {
    }
 
    @IBAction func onFavorite(_ sender: Any) {
        services.add_to_favourite(user_id: "4", datetime: Date().description, offer_id: self.offerId!.description) { (res,status) in
            if status == "ok"{
                print(res?.message ?? 0)
            }else{
                print("service error")
            }
        }
        self.favoritBtnRight.setImage(UIImage(named: "offer_favorite_selected"), for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.offerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCollectionCell", for: indexPath) as! ImagesDetailsCollectionViewCell
        cell.load_image(urlString: offerImages[indexPath.row])
        return cell
    }
    func load_image(urlString:String,imageView:UIImageView)
    {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    imageView.image = UIImage(data: data!)
                })
            }else{
                imageView.image = UIImage(named: "")
            }
        })
        task.resume()
    }
}
