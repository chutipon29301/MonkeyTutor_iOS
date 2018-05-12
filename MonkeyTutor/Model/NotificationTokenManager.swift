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
    
    var playerID: String?
    var token: String?
    var subscription: Disposable?
    
    private init() { }
    
    func registered() {
        if let user = RealmManager.shared.getCurrentUser(),
            let playerID = self.playerID {
                subscription = NetworkManager.shared.registerDeviceToken(userID: user.userID, token: playerID).subscribe {
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
