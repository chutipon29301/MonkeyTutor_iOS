//
//  NotificationTokenManager.swift
//  MonkeyTutor
//
//  Created by admin on 25/2/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation

class NotificationTokenManager{
    
    var token: String?
    
    private static var sharedNotifiationTokenManager: NotificationTokenManager = {
        let notificationTokenManager = NotificationTokenManager()
        return notificationTokenManager
    }()
    
    class func getInstance() -> NotificationTokenManager{
        return sharedNotifiationTokenManager
    }
    
    func setToken(token: String) {
        print("called")
        self.token = token
    }
    
    func registerDeviceWith(userID: String) {
        print("register")
        if let deviceToken = token {
            print("request")
            NetworkManager.getInstance().registerDevice(id: userID, token: deviceToken)
        }
    }
}
