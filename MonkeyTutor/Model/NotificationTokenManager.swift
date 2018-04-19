//
//  NotificationTokenManager.swift
//  MonkeyTutor
//
//  Created by admin on 19/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RxSwift

class NotificationTokenManager {
    
    static let shared = NotificationTokenManager()
    
    var token: String?
    var subscription: Disposable?
    
    func registerDeviceWith(userID: Int) {
        print("Called")
        if let token = token {
            subscription = NetworkManager.shared.registerDeviceToken(userID: userID, token: token).subscribe{
                switch $0 {
                case .next(_):
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }
        }
    }
    
    func cancel() {
        subscription?.dispose()
    }
}
