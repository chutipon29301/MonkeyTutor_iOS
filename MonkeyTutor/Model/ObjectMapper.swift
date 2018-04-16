//
//  ObjectMapper.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObjectMapper {
    
    static func mapLoginResult(_ jsonData: JSON) -> Bool {
        return jsonData["msg"].string == "ok" 
    }
    
    static func mapWorkflowResult(_ jsonData: JSON) -> [Workflow] {
        var workflows: [Workflow] = []
        for (_, subJson) in JSON(jsonData["nodes"]) {
            if let workflow = ObjectMapper.mapWorkflow(subJson) {
                workflows.append(workflow)
            }
        }
        return workflows
    }
    
    static func mapResposeOK(_ jsonData: JSON) -> Bool {
        return jsonData["msg"].string == "OK"
    }
    
    static func mapCreateWorkflowResult(_ jsonData: JSON) -> Workflow? {
        return ObjectMapper.mapWorkflow(jsonData)
    }
    
    private static func mapWorkflow(_ subJson: JSON) -> Workflow? {
        if let title = subJson["title"].string,
            let nodeID = subJson["nodeID"].string,
            let timestamp = subJson["timestamp"].date(),
            let createdBy = subJson["createdBy"].int,
            let owner = subJson["owner"].int,
            let parent = subJson["parent"].string,
            let subtitle = subJson["subtitle"].string,
            let detail = subJson["detail"].string
        {
            let ancestors = subJson["ancestors"].arrayValue.map({ $0.string! })
            let status = Workflow.Status.allValues
            return Workflow(title: title,
                            id: nodeID,
                            timestamp: timestamp,
                            createdBy: createdBy,
                            duedate: subJson["duedate"].date(),
                            status: status.findFrom(string: subJson["status"].string),
                            owner: owner,
                            parent: parent,
                            ancestors: ancestors,
                            subtitle: subtitle,
                            detail: detail,
                            tag: Workflow.Tags.allValues.findFrom(string: subJson["tag"].string),
                            childStatus: status.findFrom(string: subJson["childStatus"].string),
                            childOwner: subJson["childOwnerName"].string)
        } else {
            return nil
        }
    }
    
}
