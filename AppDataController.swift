//
//  AppDataController.swift
//
//  Created by Ernie Lail on 11/26/18.
//  Copyright ¬© 2018 Development. All rights reserved.
//

import UIKit
import Alamofire



class AppDataController: NSObject {

    //API URL
    let apiURL = "https://www.your-custom-api-url.com"
    
    //API User
    let user = "your-user"
    
    //User Key
    let key = "your-key"
    
    //User Secret
    let secret = "your-secret"

	//WooCommerce API URL
    let wooURL = "https://www.your-woocommerce-api-url.com"

    
    
    //Initialize Singleton 
    static let shared = AppDataController()

    
    
    
    
    
    //Generic API Request Function
    func request( with completion:@escaping ([String:Any]) -> ()) {
        
        var result = [String : Any]()

        let sig = secret.hmac(algorithm: .SHA256, key: key)

        let headers = [
                "action": "get-app-data",
                "user": user,
                "key": key,
                "sig": sig,
                "Content-Type": "text/html",
                "Accept": "application/json"
            ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
                
                if let data = response.result.value{
                    print(response.result.value)
                    result = data as! [String : Any];
                    completion(result);
                }
                else{
                    result = ["Error":"No Response From Server"];
                    completion(result);
                }
            })
        
    }
        
        
    
    
    
    
    
    //check website for stock
    func checkWCInStock(id:String, variation:String, with completion:@escaping ([String:Any]) -> ()) {
       
        var result = [String : Any]()

        //set the headers for WC API
        let headers = [
            "Content-Type": "text/html",
            "Accept": "application/json"
        ]
        
        //API target
        var target = "products/" + id
        
        if variation != "" {
           target = target + "/variations/" + variation
        }

        print("Query: \(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret )")
        
        //url request to woocommerce API to see if we have stock
        Alamofire.request(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret , method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let data = response.result.value{
               // print(response.result.value)
                result = data as! [String : Any];
                print("Stock Quantity->")
                print(result["stock_quantity"])
                completion(result);
                print(result)
            }
            else{
                result = ["Error":"No Response From Server"];
                completion(result);
                print(result)
            }
        })
        
    }
    
    
    
    
    
    
    func removeFromWCStock(id:String, variation:String, stock:Int) {
        
        var result = [String : Any]()
        
        //set the headers for WC API
        let headers = [
            "Content-Type": "text/html",
            "Accept": "application/json"
        ]
        
        //API target
        var target = "products/" + id
        
        if variation != "" {
            target = target + "/variations/" + variation
        }
        
        print("Query: \(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret )")
       
        var params = [String:Any]()
        
        if(stock > 0 ){
            params["stock_quantity"] = stock
        }
        else{
           params["stock_status"] = "outofstock"
        }
        
        //url request to woocommerce API
        Alamofire.request(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret , method: .put, parameters: params, encoding: JSONEncoding.default,headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let data = response.result.value{
                // print(response.result.value)
                result = data as! [String : Any];
                print("Stock Quantity->")
                print(result["stock_quantity"])
                print(result)
            }
            else{
                result = ["Error":"No Response From Server"];
                print(result)
            }
        })
        
    }
    
    
    
    
    
    
    
    //write new order to Woocommerce
    func writeWCOrder(jsonData:[String:Any], with completion:@escaping ([String:Any]) -> ()) {
        
        var result = [String : Any]()
                
        //set the headers for Woocommerce API
        let headers = [
            "Content-Type": "text/html",
            "Accept": "application/json"
        ]
        
        print(jsonData.description)
       
        //API target
        let target = "orders"
        
        print("Query: \(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret )")
        //url request to woocommerce API
        Alamofire.request(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret , method: .post, parameters: jsonData, encoding: JSONEncoding.default,headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let data = response.result.value{
                result = data as! [String : Any];
                completion(result);
                print(result)
            }
            else{
                result = ["Error":"No Response From Server"];
                completion(result);
                print(result)
            }
            
        })
        
    }
    
    
    
    
    
    
    //write new order to Woocommerce
    func updateWCOrder(orderNum:String, status:String, with completion:@escaping ([String:Any]) -> ()) {
        
        var result = [String : Any]()
        
        //set the headers for Woocommerce API
        let headers = [
            "Content-Type": "text/html",
            "Accept": "application/json"
        ]
        
        //API target
        let target = "orders/"+orderNum
        
        print("Query: \(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret )")
        
        
        //url request to woocommerce API to see if we have stock
        Alamofire.request(wooURL + "/wp-json/wc/v2/" + target + "?consumer_key=" + CartManager.shared.wcKey + "&consumer_secret=" + CartManager.shared.wcSecret , method: .put, parameters: ["status":status], encoding: JSONEncoding.default,headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let data = response.result.value{
                result = data as! [String : Any];
                completion(result);
                print(result)
            }
            else{
                result = ["Error":"No Response From Server"];
                completion(result);
                print(result)
            }
        })
        
    }
    
    
    
    
    
    
    
    func submitStripeTokenToBackend(headers:[String:String], completion:@escaping ([String:Any]) -> ()){
        
        var result = [String : Any]()
        
        let sig = secret.hmac(algorithm: .SHA256, key: key)
        
        //Add Auth headers to Dict which already includes Stripe token
        headers["action"] =  "stripe-charge"
        headers["user"] =  user
        headers["key"] = key
        headers["sig"] = sig
        headers["Content-Type"] = "text/html"
        headers["Accept"] = "application/json"
        
        Alamofire.request(self.apiURL, method: .post, headers: headers).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let data = response.result.value{
                print(response.result.value)
                result = data as! [String : Any];
                completion(result);
            }
            else{
                result = ["error":"error"];
                completion(result);
            }
        })
        
    }
    
    
    
    
    
    
    
    
}
