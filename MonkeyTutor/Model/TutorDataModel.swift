//
//  TutorDataModel.swift
//  MonkeyTutor
//
//  Created by admin on 27/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class Tutor: Object {
    @objc dynamic var id = 0
    @objc dynamic var nicknameEn = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
