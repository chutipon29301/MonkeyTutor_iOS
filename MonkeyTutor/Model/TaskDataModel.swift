//
//  TaskDataModel.swift
//  MonkeyTutor
//
//  Created by admin on 24/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RealmSwift

enum TaskStatus: Int {
    case none = -1
    case todo = 0
    case onProcess = 1
    case assign = 2
    case done = 3
    case complete = 4
}

class Task: Object {
    @objc dynamic var id = ""
    @objc dynamic var createOn: Date? = nil
    @objc dynamic var lastModified: Date? = nil
    @objc dynamic var title = ""
    @objc dynamic var detail = ""
    @objc dynamic var owner = ""
    @objc dynamic var createBy = ""
    @objc dynamic var modifyBy = ""
    let ancestors = List<String>()
    @objc dynamic var parent: String? = nil
    @objc dynamic var status = TaskStatus.none.rawValue
    @objc dynamic var order = 0
    @objc dynamic var remark = ""
    @objc dynamic var hasDueDate = false
    let tags = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
