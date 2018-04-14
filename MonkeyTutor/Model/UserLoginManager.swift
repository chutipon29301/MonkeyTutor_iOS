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
        subscription = NetworkManager.shared.login(userID: userID, password: CryptoJS.SHA3().hash(password)).subscribe {
            switch $0 {
            case .next(let value):
                resultDelegate?.loginResult(isVerify: ObjectMapper.mapLoginResult(value))
                break
            case .error(_):
                resultDelegate?.loginResult(isVerify: false)
                break
            case .completed:
                break
            }
        }
    }
    
    func cancel() {
        subscription?.dispose()
    }
}
