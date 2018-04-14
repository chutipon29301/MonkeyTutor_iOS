//
//  UserDAO.swift
//  MonkeyTutor
//
//  Created by admin on 14/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfo: Object {
    @objc dynamic var id = "currentUser"
    @objc dynamic var userID = 0
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
