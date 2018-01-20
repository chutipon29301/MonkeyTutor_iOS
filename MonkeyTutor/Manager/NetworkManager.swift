//
//  NetworkManager.swift
//  MonkeyTutor
//
//  Created by admin on 14/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkManager{
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    let baseURL: String
    
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
    
    func login(userID: String, password: String,callback: (_ vertified: Bool) -> ()) -> () {
        Alamofire.request(baseURL + "/post/v1/login", method: .post, parameters: ["userID":userID, "password":password], encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            switch response.result{
            case .success(let value):
                print(value)
            case .failure(let value):
                print(value)
            }
        }
    }
}

