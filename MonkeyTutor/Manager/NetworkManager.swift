//
//  NetworkManager.swift
//  MonkeyTutor
//
//  Created by admin on 14/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol LoginResultDelegate {
    func loginResult(isSuccess: Bool)
}

public class NetworkManager{
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    let baseURL: String!
    
    private init() {
        var config: NSDictionary?
        if let configPath = Bundle.main.path(forResource: "config", ofType: "plist") {
            config = NSDictionary(contentsOfFile: configPath)
            self.baseURL = config?.value(forKey: "base_url") as! String
        }else{
            self.baseURL = ""
        }
    }
    
    class func getInstance() -> NetworkManager{
        return sharedNetworkManager
    }
    
    func request(path: String, params: [String:Any], callback:@escaping (_ response: DataResponse<Any>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(baseURL + path, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON{
            response in callback(response)
        }
    }
    
    func login(userID: String, password: String,callback: LoginResultDelegate?) {
        let params: [String: String] = [
            "id": userID,
            "password": CryptoJS.SHA3().hash(password)
        ]
        self.request(path: "/post/v1/login", params: params, callback: { (response) in
            switch response.result{
            case .success(let value):
                if let delegate = callback{
                    if (JSON(value)["msg"] == "ok") {
                        delegate.loginResult(isSuccess: true)
                    }else{
                        delegate.loginResult(isSuccess: false)
                    }
                }
            case .failure( _):
                if let delegate = callback{
                    delegate.loginResult(isSuccess: false)
                }
            }
        })
        //        Alamofire.request(baseURL+"/post/v1/login", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON{response in
        //            print(type(of: response))
        //            switch response.result{
        //            case .success(let value):
        //                if let delegate = callback{
        //                    if (JSON(value)["msg"] == "ok") {
        //                        delegate.loginResult(isSuccess: true)
        //                    }else{
        //                        delegate.loginResult(isSuccess: false)
        //                    }
        //                }
        //            case .failure( _):
        //                if let delegate = callback{
        //                    delegate.loginResult(isSuccess: false)
        //                }
        //            }
        //        }
    }
}

