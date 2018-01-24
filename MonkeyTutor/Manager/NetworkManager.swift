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

protocol AddTaskResutlDelegate {
    func onAddTaskDone(isSuccess: Bool)
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
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
                    } else {
                        delegate.loginResult(isSuccess: false)
                    }
                }
                break
            case .failure( _):
                if let delegate = callback{
                    delegate.loginResult(isSuccess: false)
                }
                break
            }
        })
    }
    
    func addTask(taskName: String, taskDetail: String, taskTag: [String]?, taskDueDate: Date?, callback: AddTaskResutlDelegate?) {
        var params: [String: Any] = [
            "title": taskName,
            "detail": taskDetail
        ]
        if let tag = taskTag {
            params["tags"] = tag
        }
        if let date = taskDueDate {
            params["dueDate"] = date.millisecondsSince1970
        }
        if let userDetail = RealmManager.getInstance().getExistingLoginUser() {
            params["assigner"] = userDetail.userID
        }
        self.request(path: "/post/v1/addTask", params: params) { (response) in
            if let delegate = callback {
                switch response.result{
                case .success(let value):
                    if(JSON(value)["msg"] == "OK") {
                        delegate.onAddTaskDone(isSuccess: true)
                    } else {
                        delegate.onAddTaskDone(isSuccess: false)
                    }
                    break
                case .failure( _):
                    delegate.onAddTaskDone(isSuccess: false)
                    break
                }
            }
        }
    }
}

