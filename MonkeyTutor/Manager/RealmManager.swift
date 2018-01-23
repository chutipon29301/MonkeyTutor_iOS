//
//  RealmManager.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    private static var sharedRealmManager: RealmManager = {
        let realmManager = RealmManager()
        return realmManager
    }()
    
    class func getInstance() -> RealmManager {
        return sharedRealmManager
    }
    
    func addUser(userID: String, password: String) {
        let realm = try! Realm()
        let userInfo = UserInfo()
        userInfo.userID = userID
        userInfo.password = password
        try! realm.write {
            realm.add(userInfo)
        }
    }
    
    func checkExistingUserLogin() -> Bool {
        let realm = try! Realm()
        return realm.object(ofType: UserInfo.self, forPrimaryKey: "user") != nil
    }
    
    func getExistingLoginUser() -> UserInfo? {
        let realm = try! Realm()
        return realm.object(ofType: UserInfo.self, forPrimaryKey: "user")
    }
    
    func removeLoginUser() {
        let realm = try! Realm()
        if let userInfo = realm.object(ofType: UserInfo.self, forPrimaryKey: "user") {
            try! realm.write {
                realm.delete(userInfo)
            }
        }
    }
}
