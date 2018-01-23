//
//  UserDataModel.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfo: Object {
    @objc dynamic var id = "user"
    @objc dynamic var userID = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
