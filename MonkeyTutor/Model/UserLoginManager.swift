//
//  UserLoginManager.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginResultDelegate {
    func loginResult(isVerify: Bool)
}

class UserLoginManager {
    
    static let shared = UserLoginManager()
    private var subscription: Disposable?
    
    func login(userID: Int, password: String, resultDelegate: LoginResultDelegate?) {
        login(userID: userID, password: password, resultDelegate: resultDelegate, completion: nil)
    }
    
    func login(userID: Int, password: String, resultDelegate: LoginResultDelegate?, completion: (() -> Void)?) {
        subscription = NetworkManager.shared.login(userID: userID, password: CryptoJS.SHA3().hash(password)).subscribe {
            switch $0 {
            case .next(let value):
                let isVerify = ObjectMapper.mapLoginResult(value)
                resultDelegate?.loginResult(isVerify: isVerify)
                if isVerify && !self.isCurrentUserLoggin() {
                    RealmManager.shared.addCurrentUser(userID: userID, password: password)
                    completion?()
                }
                break
            case .error(_):
                resultDelegate?.loginResult(isVerify: false)
                break
            case .completed:
                break
            }
        }
    }
    
    func reauthenticate(completion: (() -> Void)?) {
        if let user = getCurrentUser() {
            login(userID: user.userID, password: user.password, resultDelegate: nil, completion: completion)
        }
    }
    
    func isCurrentUserLoggin() -> Bool {
        return RealmManager.shared.getCurrentUser() != nil
    }
    
    func getCurrentUser() -> UserInfo? {
        return RealmManager.shared.getCurrentUser()
    }
    
    func logout() {
        RealmManager.shared.removeCurrentUser()
    }
    
    func cancel() {
        subscription?.dispose()
    }
}
