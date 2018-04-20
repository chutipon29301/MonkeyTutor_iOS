//
//  Extension.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs
import SwiftyJSON

extension Formatter {
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
}

extension UIViewController {
    
    func presentDialog(_ view: UIViewController, size: CGSize?, completion: (() -> Void)?) {
        let dialogTransistionController = MDCDialogTransitionController()
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = dialogTransistionController
        if let size = size {
            view.preferredContentSize = size
        }
        present(view, animated: true, completion: completion)
    }
    
    func presentAlertDialog(text: String) {
        presentDialog(AlertViewController(labelWith: text), size: CGSize(width: 300, height: 250), completion: nil)
    }
    
}

extension Date {
    
    var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: self)
        }
    }
    
}

extension Array where Element: Workflow {
    
    func filterWith(tags: Workflow.Tags) -> [Workflow] {
        return self.filter { $0.tag == tags }
    }
    
    func filterWith(status: Workflow.Status) -> [Workflow] {
        return self.filter { $0.status == status }
    }
    
    func countTags(_ tags: Workflow.Tags) -> Int {
        return filterWith(tags: tags).count
    }
    
}

public protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    private static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
    
}

extension Array where Element == Workflow.Status {
    
    func findFrom(string: String?) -> Workflow.Status {
        if let value = string {
            let values = Workflow.Status.allValues
            let index = values.index(where: { $0.rawValue == value })
            return values[index ?? values.count - 1]
        } else {
            return .none
        }
        
    }
    
}

extension Array where Element == Workflow.Tags {
    
    func findFrom(string: String?) -> Workflow.Tags {
        if let value = string {
            let values = Workflow.Tags.allValues
            let index = values.index(where: { $0.rawValue == value })
            return values[index ?? values.count - 1]
        } else {
            return .other
        }
        
    }
    
}

extension JSON {
    
    var date: Date? {
        get {
            if let string = self.string {
                return Formatter.iso8601.date(from: string)
            } else {
                return nil
            }
        }
    }
    
    var loginResult: Bool {
        get {
            return self["msg"].string == "ok"
        }
    }
    
    var responseOK: Bool {
        get {
            return self["msg"].string == "OK"
        }
    }
    
    var nodeID: String? {
        get {
            return self["_id"].string
        }
    }
    
    var workflow: Workflow? {
        get {
            if let title = self["title"].string,
                let nodeID = self["nodeID"].string,
                let timestamp = self["timestamp"].date,
                let createdBy = self["createdBy"].int,
                let owner = self["owner"].int,
                let parent = self["parent"].string,
                let subtitle = self["subtitle"].string,
                let detail = self["detail"].string,
                let canDelete = self["canDelete"].bool {
                let ancestors = self["ancestors"].arrayValue.map({ $0.string! })
                let status = Workflow.Status.allValues
                return Workflow(title: title,
                                id: nodeID,
                                timestamp: timestamp,
                                createdBy: createdBy,
                                duedate: self["duedate"].date,
                                status: status.findFrom(string: self["status"].string),
                                owner: owner,
                                parent: parent,
                                ancestors: ancestors,
                                subtitle: subtitle,
                                detail: detail,
                                tag: Workflow.Tags.allValues.findFrom(string: self["tag"].string),
                                childStatus: status.findFrom(string: self["childStatus"].string),
                                childOwner: self["childOwnerName"].string,
                                canDelete: canDelete)
            } else {
                return nil
            }
        }
    }
    
    var workflows: [Workflow] {
        var workflows: [Workflow] = []
        for (_, subJson) in JSON(self["nodes"]) {
            if let workflow = subJson.workflow {
                workflows.append(workflow)
            }
        }
        return workflows
    }
    
    var tutor: Tutor? {
        get {
            if let id = self["_id"].int,
                let nicknameEn = self["nicknameEn"].string {
                return Tutor(id: id, nicknameEn: nicknameEn)
            } else {
                return nil
            }
        }
    }
    
    var tutors: [Tutor] {
        get {
            var tutors: [Tutor] = []
            for(_, subJson) in JSON(self["tutors"]) {
                if let tutor = subJson.tutor {
                    tutors.append(tutor)
                }
            }
            return tutors
        }
    }
    
}
