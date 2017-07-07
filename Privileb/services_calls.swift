//
//  services_calls.swift
//  S-Shope
//
//  Created by ilove-apple.com on 6/27/17.
//  Copyright © 2017 Evan. All rights reserved.
//

import Foundation
import Alamofire


class services_calls {
    
    var user_m : user!
    var offers : [offer] = []
    var offer_detailss : offer_details?
    var categories : [categoryy] = []
    var regions : [region] = []
    var districts : [district] = []
    var countries : [country] = []
    var payment_methods : [payment_method] = []
    var cards : [card] = []
    var sub_categories : [sub_category] = []
    var branches : [branch] = []
    var pages : [static_page] = []
    var favourites : [favourite] = []
    var postRes : postResponse?

    
    
    func parsUserLogin(JSONData: Data)  {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
            self.user_m = user(result: readableJSON)
        }catch(_) {
            print("error parsing")
        }
    }
    
    func parseData(JSONData: Data , class_name : String) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
             self.postRes = postResponse(result: readableJSON)
            if let stringArray = readableJSON["data"] as? [[String :Any]]{
                let elements = readableJSON["data"] as! [[String: Any]]

                for element in elements {
                    if(class_name == "user"){
                    self.user_m = user(result: element)
                    }
                    
                    if(class_name == "offer"){
                    self.offers.append(offer(result: element))
                    }

                    
                    if(class_name == "category"){
                    self.categories.append(categoryy(result: element))
                    }

                    
                    if(class_name == "region"){
                    self.regions.append(region(result: element))
                    }

                    
                    if(class_name == "district"){
                    self.districts.append(district(result: element))
                    }

                    
                    if(class_name == "country"){
                    self.countries.append(country(result: element))
                    }

                    
                    if(class_name == "payment_method"){
                    self.payment_methods.append(payment_method(result: element))
                    }

                    
                    if(class_name == "card"){
                    self.cards.append(card(result: element))
                    }

                    
                    if(class_name == "sub_category"){
                    self.sub_categories.append(sub_category(result: element))
                    }

                    
                    if(class_name == "branch"){
                    self.branches.append(branch(result: element))
                    }

                    
                    if(class_name == "static_page"){
                    self.pages.append(static_page(result: element))
                    }
                    
                    if(class_name == "favourite"){
                        self.favourites.append(favourite(result: element))
                    }
                    
                    if(class_name == "details"){
                        self.offer_detailss = offer_details(result: element)
                    }
                 //   self.items.append(item(result: element))
                }}
            else {
                if class_name == "message" {
                    self.postRes = postResponse(result: readableJSON)
                }
            }
         
            
        }
        catch {
            print(error)
        }
    }

    
    func login(email : String , password : String, onComplete: @escaping (user?,String,postResponse?) -> Void){
        
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request("http://privileb.com/webservices/login.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parsUserLogin(JSONData: response.data!)
                onComplete(self.user_m,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//        http://privileb.com/webservices/login.php
//        {"email":"carla.zaiter@bloomay.com","password":"123456"}
    }
    
    
    func logout(user_id : String, onComplete: @escaping (postResponse?,String) -> Void) {
        let parameters: Parameters = [
            "user_id": user_id       ]
        
        Alamofire.request("http://privileb.com/webservices/logout.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                do {
                    let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options:.allowFragments) as! [String: Any]
                    self.postRes = postResponse(result: readableJSON)
                    onComplete(self.postRes,"ok")
                }catch(_) {
                    onComplete(nil,"error")
            }            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"error")
            }}
        
        
//    http://privileb.com/webservices/logout.php
//        {"user_id":"4"}
    
    }
    
    func register(datetime : String ,fname : String ,lname : String , serial_number : String , birthdate : String , gender : String , country_id : String , email : String , mobile_number : String , password : String ){
        let parameters: Parameters = [
            "datetime": datetime,
            "fname": fname,
            "lname": lname,
            "serial_number": serial_number,
            "birthdate": birthdate,
            "gender": gender,
            "country_id": country_id,
            "email": email,
            "mobile_number": mobile_number,
            "password" : password]
        
        Alamofire.request("http://privileb.com/webservices/register.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!,  class_name: "user")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}

        
//    http://privileb.com/webservices/register.php
        
//        {"datetime":"2017-05-09 10:59:00","fname":"Carla","lname":"Zaiter","serial_number":"111111111","birthdate":"1988-02-02","gender":"female","country_id":"1","email":"carla.zaiter@bloomay.com","mobile_number":"03747474","password":"123456"}
    }
    
    
    func forgot_password(email : String ,onComplete: @escaping (postResponse?,String) ->Void){
        let parameters: Parameters = [
            "email": email]
        
        Alamofire.request("http://privileb.com/webservices/forgot_password.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "message")
                onComplete(self.postRes,"ok")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)")
            }}


//    http://privileb.com/webservices/forgot_password.php
//        {"email":"carla.zaiter@bloomay.com"}
    
    
    }
    
    func get_nearby_offers(latitude : String , longtude : String , date : String, onComplete: @escaping ([offer]?,String,postResponse?) -> Void){
        self.offers.removeAll()
        let parameters: Parameters = [
            "latitude": latitude,
            "longitude": longtude,
            "date" : date]
        
        Alamofire.request("http://privileb.com/webservices/nearby_offers.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
                onComplete(self.offers,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}

//    http://privileb.com/webservices/nearby_offers.php
//        {"latitude":"33.8869","longitude":"35.51919","date":"2017-05-09"}
    
    }
    
    func get_featured_offers(country_code : String , date : String , onComplete: @escaping ([offer]?,String,postResponse?) -> Void){
        self.offers.removeAll()
        let parameters: Parameters = [
            "country_code": country_code,
            "date" : date]
        Alamofire.request("http://privileb.com/webservices/featured_offers.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
                onComplete(self.offers,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/featured_offers.php
//        {"country_code":"lb","date":"2017-05-09"}
    
    }
    
    func get_all_offers(country_code : String , date : String, onComplete: @escaping ([offer]?,String,postResponse?) -> Void){
        self.offers.removeAll()
        let parameters: Parameters = [
            "country_code": country_code,
            "date" : date]
        Alamofire.request("http://privileb.com/webservices/offers_list.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
                onComplete(self.offers,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}

//    http://privileb.com/webservices/offers_list.php
//    {"country_code":"lb","date":"2017-05-09"}
    }
    //to check
    func get_offer_details(offer_id : String, onComplete: @escaping (offer_details?,String,postResponse?) -> Void){
        let parameters: Parameters = [
            "offer_id": offer_id
            ]
        
        Alamofire.request("http://privileb.com/webservices/offer_details.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "details")
                onComplete(self.offer_detailss!,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}

//        http://privileb.com/webservices/offer_details.php
//        {"offer_id":"5"}
    }
    //to check
    func get_static_page(country_code : String ,onComplete: @escaping ([static_page]?,String,postResponse?) -> Void){
        self.pages.removeAll()
        let parameters: Parameters = [
            "country_code": country_code
        ]
        
        Alamofire.request("http://privileb.com/webservices/get_static_pages.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            self.pages.removeAll()
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "static_page")
                onComplete(self.pages,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}

//    http://privileb.com/webservices/get_static_pages.php
//        {"country_code":"lb"}
    
    }
    func get_favourite_list (user_id : String , date : String, onComplete: @escaping ([favourite]?,String,postResponse?) -> Void){
        self.favourites.removeAll()
        let parameters: Parameters = [
            "user_id": user_id,
            "date" : date]
        
        
        Alamofire.request("http://privileb.com/webservices/get_favorites_list.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "favourite")
                onComplete(self.favourites,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
        
//    http://privileb.com/webservices/get_favorites_list.php
//        {"user_id":"4","date":"2017-05-09"}
    }
    
    func add_to_favourite(user_id : String , datetime : String , offer_id : String , onComplete: @escaping (postResponse? ,String) -> Void){
        let parameters: Parameters = [
            "user_id": user_id,
            "datetime" : datetime,
            "offer_id" :offer_id ]
        
        Alamofire.request("http://privileb.com/webservices/add_to_favorites.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "message")
                onComplete(self.postRes!,"ok")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)")
            }}

        
//    http://privileb.com/webservices/add_to_favorites.php
//        {"user_id":"4","datetime":"2017-05-09 14:21:50","offer_id":"16"}
    }
    
    func remove_from_favourite(favorite_id : String){
        let parameters: Parameters = [
            "favorite_id": favorite_id
        ]
        
        
        Alamofire.request("http://privileb.com/webservices/remove_from_favorites.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "message")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}

//    http://privileb.com/webservices/remove_from_favorites.php
//        {"favorite_id":"1"}
    }
    func get_categories(country_code : String, onComplete: @escaping ([categoryy]?,String,postResponse?) -> Void){
        self.categories.removeAll()
        let parameters: Parameters = [
            "country_code": country_code
        ]
        
        
        Alamofire.request("http://privileb.com/webservices/get_categories.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "category")
                onComplete(self.categories,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/get_categories.php
//        {"country_code":"lb"}
    }
    
    func add_to_news_letter(name : String , email : String , mobile_number : String){
        let parameters: Parameters = [
            "name": name,
            "email" : email,
            "mobile_number" :mobile_number ]
        
        Alamofire.request("http://privileb.com/webservices/newsletter.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "message")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}

//     http://privileb.com/webservices/newsletter.php
//        {"name":"carla wehbi","email":"carlawehbi@gmail.com","mobile_number":"03696998"}
    }
    //to check
    func get_card(user_id : String){
        let parameters: Parameters = [
            "user_id": user_id
        ]
        
        Alamofire.request("http://privileb.com/webservices/get_card.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "card")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}

//     http://privileb.com/webservices/get_card.php
//    {"user_id":"4"}
    }
    
    func get_countries(onComplete: @escaping ([country]?,String,postResponse?) -> Void){
        self.countries.removeAll()
        
        Alamofire.request("http://privileb.com/webservices/get_countries.php").responseJSON() { response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "country")
                onComplete(self.countries,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/get_countries.php
    }
    
    func get_districts(country_code : String, onComplete: @escaping ([district]?,String,postResponse?) -> Void){
        districts.removeAll()
        let parameters: Parameters = [
            "country_code": country_code
        ]
        
        Alamofire.request("http://privileb.com/webservices/get_districts.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "district")
               onComplete(self.districts,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/get_districts.php
//        {"country_code":"lb"}
    }
    //to check
    func buy_card(){
//    http://privileb.com/webservices/buy_card.php
//        {"fname":"Carla","lname":"Zaiter","email":"carla.zaiter@bloomay.com","mobile_number":"03747474","address":"Jdeideh, Bakhos Canter, 6th FLoor","comments":"From 9am-6pm","payment_method_id":"2","order_status_id":"2","datetime":"2017-05-09 11:07:00"}
    }
    
    func get_payment_methods()-> [payment_method]{
        self.payment_methods.removeAll()
        
        Alamofire.request("http://privileb.com/webservices/get_payment_method.php").responseJSON() { response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "payment_method")
                
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        
        return self.payment_methods

//    http://privileb.com/webservices/get_payment_method.php
        
        
    }
    
    func search_offers(category_ids : String ,country_code : String , date : String ,district_ids : String ,keyword : String , onComplete: @escaping ([offer]?,String,postResponse?) -> Void){
        self.offers.removeAll()
        let parameters: Parameters = [
            "category_ids": category_ids,
            "country_code": country_code,
            "date": date,
            "district_ids": district_ids,
            "keyword": keyword
        ]
        
        
        Alamofire.request("http://privileb.com/webservices/search_offers.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
                onComplete(self.offers,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/search_offers.php
//        {"category_ids":"9,2","country_code":"lb","date":"2017-06-12","district_ids":"17","keyword":"b"}
    }
    
    func search_categories(country_code : String , keyword : String) -> [categoryy]{
        self.categories.removeAll()
        let parameters: Parameters = [
            "country_code": country_code,
            "keyword": keyword
        ]
        Alamofire.request("http://privileb.com/webservices/search_categories.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "category")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
            return self.categories
//    http://privileb.com/webservices/search_categories.php
//    {"country_code":"lb","keyword":"b"}
    }
    
    func search_locations(country_code : String , keyword : String) -> [district]{
        self.districts.removeAll()
        let parameters: Parameters = [
            "country_code": country_code,
            "keyword": keyword
        ]
        Alamofire.request("http://privileb.com/webservices/search_districts.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "district")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        return self.districts
//    http://privileb.com/webservices/search_districts.php
//        {"country_code":"lb","keyword":"b"}
    }
    
    func get_sub_categories(category_id : String)-> [sub_category]{
        self.sub_categories.removeAll()
        let parameters: Parameters = [
            "category_id": category_id
        ]
        Alamofire.request("http://privileb.com/webservices/get_sub_categories.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "sub_category")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        return self.sub_categories
//    http://privileb.com/webservices/get_sub_categories.php
//        {"category_id":"9"}
    }
    
    func get_regions(district_id : String, onComplete: @escaping ([region]?,String,postResponse?) -> Void){
        self.regions.removeAll()
        let parameters: Parameters = [
            "district_id": district_id
        ]
        Alamofire.request("http://privileb.com/webservices/get_regions.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "region")
                onComplete(self.regions,"ok",self.postRes)
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                onComplete(nil,"Request failed with error: \(error)",nil)
            }}
//    http://privileb.com/webservices/get_regions.php
//        {"district_id":"9"}
    }
    
    func seach_favourites(date : String , keyword: String , user_id: String)-> [favourite]{
        self.favourites.removeAll()
        let parameters: Parameters = [
            "date": date,
            "keyword" : keyword,
            "user_id" :user_id
        ]
        Alamofire.request("http://privileb.com/webservices/search_favorites.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "favourite")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        
        return self.favourites

//    http://privileb.com/webservices/search_favorites.php
//        {"date":"2017-06-12","keyword":"max 4 ","user_id":"4"}
    }
    
    func filter_by_sub_category(date : String ,country_code : String ,sub_category_id : String )-> [offer]{
        self.offers.removeAll()
        let parameters: Parameters = [
            "date": date,
            "country_code" : country_code,
            "sub_category_id" :sub_category_id
        ]
        Alamofire.request("http://privileb.com/webservices/offers_by_sub_categories.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        return self.offers
//    http://privileb.com/webservices/offers_by_sub_categories.php
//        {"date":"2017-06-12","country_code":"lb","sub_category_id":"4"}
    }
    
    func filter_by_region(date : String ,country_code : String , region_id : String )-> [offer]{
        self.offers.removeAll()
        let parameters: Parameters = [
            "date": date,
            "country_code" : country_code,
            "region_id" :region_id
        ]
        Alamofire.request("http://privileb.com/webservices/offers_by_regions.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        
        return self.offers

//    http://privileb.com/webservices/offers_by_regions.php
//        {"date":"2017-06-12","country_code":"lb","region_id":"85"}
    }
    
    func get_fav_by_uid_oid(user_id : String , offer_id : String)->[offer]{
        self.offers.removeAll()
        let parameters: Parameters = [
            "user_id": user_id,
            "offer_id" : offer_id
             ]
        Alamofire.request("http://privileb.com/webservices/get_favorite_by_userid_offerid.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(){response in
            switch response.result {
            //success
            case .success( _):
                self.parseData(JSONData: response.data!, class_name: "offer")
            //failure
            case .failure(let error):
                print("Request failed with error: \(error)")
                
            }}
        return self.offers
//    http://privileb.com/webservices/get_favorite_by_userid_offerid.php
//        {"user_id":"4", "offer_id":"126"}
    }
    
}
