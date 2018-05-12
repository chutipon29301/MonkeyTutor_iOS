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
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func addCurrentUser(userID: Int, password: String) {
        let userInfo = UserInfo()
        userInfo.userID = userID
        userInfo.password = password
        removeCurrentUser()
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
    
    func addTutorColor(nicknameEn: String, red: Double, green: Double, blue: Double) {
        if let tutorColor = getTutorColor(of: nicknameEn) {
            try! realm.write {
                tutorColor.colorR = red
                tutorColor.colorG = green
                tutorColor.colorB = blue
            }
        } else {
            let color = TutorColor()
            color.tutorNicknameEn = nicknameEn
            color.colorR = red
            color.colorG = green
            color.colorB = blue
            try! realm.write {
                realm.add(color)
            }
        }
        
    }
    
    func getTutorColor(of name: String) -> TutorColor? {
        return realm.object(ofType: TutorColor.self, forPrimaryKey: name)
    }
}
