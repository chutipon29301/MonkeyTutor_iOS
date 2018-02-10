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
import RealmSwift
import ObjectMapper

protocol ListTaskResultDelegate {
    func onListTaskDone(data: Any?)
}

protocol ListTutorResultDelegate {
    func onListTutorDone(data: Any?)
}

protocol RequestResultDelegate {
    func onRequestResultDone(isSuccess: Bool)
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
    let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
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
    
    func request(path: String, params: [String: Any], callback: @escaping (_ response: DataResponse<Any>) -> Void) {
        Alamofire.request(baseURL + path, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON{
            response in callback(response)
        }
    }
    
    func login(userID: String, password: String,callback: RequestResultDelegate?) {
        var request = URLRequest(url: NSURL.init(string: baseURL + "/post/v1/login")! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 3
        let postString = "id=\(userID)&password=\(CryptoJS.SHA3().hash(password))"
        request.httpBody = postString.data(using: .utf8)
        
        Alamofire.request(request).responseJSON {
            response in
            switch response.result{
            case .success(let value):
                if let delegate = callback{
                    if (JSON(value)["msg"] == "ok") {
                        delegate.onRequestResultDone(isSuccess: true)
                    } else {
                        delegate.onRequestResultDone(isSuccess: false)
                    }
                }
                break
            case .failure( _):
                if let delegate = callback{
                    delegate.onRequestResultDone(isSuccess: false)
                }
                break
            }
        }
    }
    
    func addTask(taskName: String, taskDetail: String, taskTag: [String]?, taskDueDate: Date?, callback: RequestResultDelegate?) {
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
                        delegate.onRequestResultDone(isSuccess: true)
                    } else {
                        delegate.onRequestResultDone(isSuccess: false)
                    }
                    break
                case .failure( _):
                    delegate.onRequestResultDone(isSuccess: false)
                    break
                }
            }
        }
    }
    
    func listTask(callback: ListTaskResultDelegate?) {
        guard let userDetail = RealmManager.getInstance().getExistingLoginUser(),
            let delegate = callback
            else { return }
        let params: [String: String] = [
            "userID": userDetail.userID
        ]
        self.request(path: "/post/v1/listUserTask", params: params, callback: { (response) in
            switch response.result{
            case .success(let value):
                delegate.onListTaskDone(data: value)
                break
            case .failure( _):
                delegate.onListTaskDone(data: nil)
                break
            }
        }
        )
    }
    
    func changeStatus(taskID: String, taskStatus: TaskStatus, callback: RequestResultDelegate?) {
        guard let delegate = callback else { return }
        let params: [String: String] = [
            "taskID": taskID,
            "taskStatus": "\(taskStatus.rawValue)"
        ]
        self.request(path: "/post/v1/changeTaskStatus", params: params) { (response) in
            switch response.result{
            case .success(let value):
                if(JSON(value)["msg"] == "OK") {
                    delegate.onRequestResultDone(isSuccess: true)
                }else {
                    delegate.onRequestResultDone(isSuccess: false)
                }
                break
            case .failure( _):
                delegate.onRequestResultDone(isSuccess: false)
                break
            }
        }
    }
    
    func listTutor(callback: ListTutorResultDelegate?) {
        guard let delegate = callback else { return }
        self.request(path: "/post/v1/listTutorJson", params: ["":""]) { (response) in
            switch response.result{
            case .success(let value):
                delegate.onListTutorDone(data: value)
                break
            case .failure( _):
                delegate.onListTutorDone(data: nil)
                break
            }
        }
    }
    
    func assignTask(taskID: String, tutorID: [Int], callback: RequestResultDelegate?) {
        guard let userDetail = RealmManager.getInstance().getExistingLoginUser(),
            let delegate = callback
            else { return }
        let params: [String: Any] = [
            "assigner": userDetail.userID,
            "assignees": tutorID,
            "taskID": taskID
        ]
        self.request(path: "/post/v1/assignTask", params: params) { (response) in
            switch response.result{
            case .success(let value):
                if(JSON(value)["msg"] == "OK") {
                    delegate.onRequestResultDone(isSuccess: true)
                } else {
                    delegate.onRequestResultDone(isSuccess: false)
                }
                break
            case .failure( _):
                delegate.onRequestResultDone(isSuccess: false)
                break
            }
        }
    }
    
    func deleteTask(taskID: String, callback: RequestResultDelegate?) {
        guard let delegate = callback else { return }
        let params: [String: Any] = [
            "taskID": taskID
        ]
        self.request(path: "/post/v1/deleteTask", params: params) { (response) in
            switch response.result{
            case .success(let value):
                if(JSON(value)["msg"] == "OK") {
                    delegate.onRequestResultDone(isSuccess: true)
                } else {
                    delegate.onRequestResultDone(isSuccess: false)
                }
                break
            case .failure( _):
                delegate.onRequestResultDone(isSuccess: false)
                break
            }
        }
    }
}

