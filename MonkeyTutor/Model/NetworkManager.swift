//
//  NetworkManager.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let shared = NetworkManager(baseURL: "http://192.168.1.38:8080")
    
    let _baseURL: String
    
    init(baseURL: String) {
        _baseURL = baseURL
    }
    
    private func get(url: String) -> Observable<JSON> {
        
        return Observable.create {
            observer -> Disposable in
            let request = Alamofire
                .request(self._baseURL + url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil)
                .responseJSON {
                switch $0.result {
                case .success(let value):
                    observer.onNext(JSON(value))
                    observer.onCompleted()
                    break
                case .failure(let error):
                    UserLoginManager.shared.reauthenticate(completion: nil)
                    observer.onError(error)
                    break
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func post(url: String, params: [String: Any]?) -> Observable<JSON> {
        return Observable.create {
            observer -> Disposable in
            let request = Alamofire.request(self._baseURL + url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                switch $0.result {
                case .success(let value):
                    observer.onNext(JSON(value))
                    observer.onCompleted()
                    break
                case .failure(let error):
                    UserLoginManager.shared.reauthenticate(completion: nil)
                    observer.onError(error)
                    break
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func login(userID: Int, password: String) -> Observable<JSON> {
        return post(url: "/post/v1/login", params: [
            "id": userID,
            "password": password
        ])
    }
    
    func listWorkflow() -> Observable<JSON> {
        return post(url: "/v2/workflow/list", params: nil)
    }
    
    func createWorkflow(title: String, subtitle: String, duedate: Date?, tag: String, detail: String) -> Observable<JSON> {
        var param: [String: Any] = [
            "title": title,
            "subtitle": subtitle,
            "tag": tag,
            "detail": detail
        ]
        if let duedate = duedate {
            param["duedate"] = duedate
        }
        return post(url: "/v2/workflow/createWorkflow", params: param)
    }
    
    func workflowNote(workflowID: String) -> Observable<JSON> {
        return post(url: "/v2/workflow/note", params: ["workflowID": workflowID])
    }
    
    func workflowTodo(workflowID: String) -> Observable<JSON> {
        return post(url: "/v2/workflow/todo", params: ["workflowID": workflowID])
    }
    
    func workflowInProgress(workflowID: String) -> Observable<JSON> {
        return post(url: "/v2/workflow/inprogress", params: ["workflowID": workflowID])
    }
    
    func workflowDelete(workflowID: String) -> Observable<JSON> {
        return post(url: "/v2/workflow/delete", params: ["workflowID": workflowID])
    }
    
    func assign(workflowID: String, to owner: Int, subtitle: String?, detail: String?, duedate: Date?) -> Observable<JSON> {
        var param: [String: Any] = [
            "workflowID": workflowID,
            "owner": owner
        ]
        if let subtitle = subtitle {
            param["subtitle"] = subtitle
        }
        if let detail = detail {
            param["detail"] = detail
        }
        if let duedate = duedate {
            param["duedate"] = duedate
        }
        return post(url: "/v2/workflow/assign", params: param)
    }
    
    func workflowDone(workflowID: String) -> Observable<JSON> {
        return post(url: "/v2/workflow/done", params: ["workflowID": workflowID])
    }
    
    func listTutor() -> Observable<JSON> {
        return post(url: "/v2/tutor/list", params: nil)
    }
    
    func registerDeviceToken(userID: Int, token: String) -> Observable<JSON> {
        return post(url: "/post/v1/registeriOSDeviceToken", params: [
                "id": userID,
                "token": token
            ])
    }
    
}
