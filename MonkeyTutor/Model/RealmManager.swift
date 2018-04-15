//
//  RealmManager.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    let realm: Realm
    
    private init() {
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func addCurrentUser(userID: Int, password: String) {
        let userInfo = UserInfo()
        userInfo.userID = userID
        userInfo.password = password
        try! realm.write {
            realm.add(userInfo)
        }
    }
    
    
    func getCurrentUser() -> UserInfo? {
        return realm.object(ofType: UserInfo.self, forPrimaryKey: "currentUser")
    }
    
    func removeCurrentUser() {
        if let userInfo = realm.object(ofType: UserInfo.self, forPrimaryKey: "currentUser") {
            try! realm.write {
                realm.delete(userInfo)
            }
        }
    }
}
