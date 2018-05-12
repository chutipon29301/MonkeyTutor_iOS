//
//  TutorColorDAO.swift
//  MonkeyTutor
//
//  Created by admin on 12/5/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

class TutorColor: Object {
    @objc dynamic var tutorNicknameEn = ""
    @objc dynamic var colorR = 0.0
    @objc dynamic var colorG = 0.0
    @objc dynamic var colorB = 0.0
    
    override static func primaryKey() -> String? {
        return "tutorNicknameEn"
    }
}
