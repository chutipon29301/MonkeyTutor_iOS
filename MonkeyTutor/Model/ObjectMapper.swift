//
//  ObjectMapper.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

class ObjectMapper {
    
    static func mapLoginResult(_ jsonData: JSON) -> Bool {
        return jsonData["msg"].string == "ok" 
    }
    
    static func mapWorkflowResult(_ jsonData: JSON) -> [Workflow] {
        var workflows: [Workflow] = []
        for (_, subJson) in JSON(jsonData["nodes"]) {
            let _title = subJson["title"].string
            let _nodeID = subJson["nodeID"].string
            let _timestamp = Formatter.iso8601.date(from: subJson["timestamp"].string!)
            let _createdBy = subJson["createdBy"].int
            var _duedate: Date? = nil
            if let due = subJson["duedate"].string {
                _duedate = Formatter.iso8601.date(from: due)
            }
            let _status = subJson["status"].string
            let _owner = subJson["owner"].int
            let _parent = subJson["parent"].string
            let _ancestors = subJson["ancestors"].arrayValue.map{$0.string!}
            let _subtitle = subJson["subtitle"].string
            let _detail = subJson["detail"].string
            var _tag = "other"
            if let tag = subJson["tag"].string {
                _tag = tag
            }
            if let title = _title, let id = _nodeID, let timestamp = _timestamp, let createdBy = _createdBy, let status = _status, let owner = _owner, let parent = _parent, let subtitle = _subtitle, let detail = _detail {
                let workflow = Workflow(title: title, id: id, timestamp: timestamp, createdBy: createdBy, duedate: _duedate, status: status, owner: owner, parent: parent, ancestors: _ancestors, subtitle: subtitle, detail: detail, tag: _tag)
                workflows.append(workflow)
            }
        }
        return workflows
    }
    
}
