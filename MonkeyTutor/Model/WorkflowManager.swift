//
//  WorkflowManager.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RxSwift

protocol WorkflowUpdaterDelegate {
    func workflowDataUpdate(success: Bool)
}

protocol WorkflowUpdateResultDelegate {
    func workflowUpdated(workflow: Workflow?)
}

class WorkflowManager {
    
    static let shared = WorkflowManager()
    
    private var _workflows: [Workflow] = []
    private var subscription: Disposable?
    private var _delegate: WorkflowUpdaterDelegate?
    
    var delegate: WorkflowUpdaterDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    private init() {
        updateWorkflow()
    }
    
    var workflows: [Workflow] {
        get {
            return _workflows
        }
    }
    
    func updateWorkflow() {
        subscription = NetworkManager.shared.listWorkflow().subscribe {
            switch $0 {
            case.next(let value):
                self._workflows = ObjectMapper.mapWorkflowResult(value)
                self._delegate?.workflowDataUpdate(success: true)
                break
            case .error(_):
                self._delegate?.workflowDataUpdate(success: false)
                break
            case .completed:
                break
            }
        }
    }
    
    func cancel() {
        subscription?.dispose()
    }
    
    func createWorkflow(title: String, subtitle: String, duedate: Date?, tag: String, detail: String, delegate: WorkflowUpdateResultDelegate?) {
        subscription = NetworkManager.shared.createWorkflow(title: title, subtitle: subtitle, duedate: duedate, tag: tag, detail: detail).subscribe {
            switch $0 {
            case .next(let value):
                if let delegate = delegate {
                    delegate.workflowUpdated(workflow: ObjectMapper.mapCreateWorkflowResult(value))
                }
                break
            case .error(_):
                delegate?.workflowUpdated(workflow: nil)
                break
            case .completed:
                break
            }
        }
    }
    
}

class Workflow {
    
    enum Tags: String, EnumCollection {
        case hybrid, app, test, web, design, other
        
        func value() -> String {
            switch self {
            case .hybrid:
                return "Hybrid"
            case .app:
                return "App"
            case .test:
                return "Test"
            case .web:
                return "Web"
            case .design:
                return "Design"
            case .other:
                return "Other"
            }
        }
    }
    
    enum Status: String, EnumCollection {
        case note, todo, inprogress, assign, done, complete, none
        
        func value() -> String {
            switch self {
            case .note:
                return "Note"
            case .todo:
                return "Todo"
            case .inprogress:
                return "In progress"
            case .assign:
                return "Assign"
            case .done:
                return "Done"
            case .complete:
                return "Complete"
            case .none:
                return "None"
            }
        }
    }
    
    private var _title: String!
    private var _nodeID: String!
    private var _timestamp: Date!
    private var _createdBy: Int!
    private var _duedate: Date?
    private var _status: Status!
    private var _owner: Int!
    private var _parent: String!
    private var _ancestors: [String]!
    private var _subtitle: String!
    private var _detail: String!
    private var _tag: Tags!
    private var _childStatus: Status?
    private var _childOwner: String?
    
    init(title: String, id: String, timestamp: Date, createdBy: Int, duedate: Date?, status: Status, owner: Int, parent: String, ancestors: [String], subtitle: String, detail: String, tag: Tags, childStatus: Status?, childOwner: String?) {
        _title = title
        _nodeID = id
        _timestamp = timestamp
        _createdBy = createdBy
        _duedate = duedate
        _status = status
        _owner = owner
        _parent = parent
        _ancestors = ancestors
        _subtitle = subtitle
        _detail = detail
        _tag = tag
        _childStatus = childStatus
        _childOwner = childOwner
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    var subtitle: String {
        get {
            return _subtitle
        }
    }
    
    var status: Status {
        get {
            return _status
        }
    }
    
    var tag: Tags {
        get {
            return _tag
        }
    }
    
    var detail: String {
        get {
            return _detail
        }
    }
    
    var duedateString: String {
        get {
            if let duedate = _duedate {
                return duedate.dateString
            } else {
                return "none"
            }
        }
    }
    
    var childStatus: Status {
        get {
            if let status = _childStatus {
                return status
            } else {
                return .none
            }
        }
    }
    
    var childOwner: String {
        get {
            if let childOwner = _childOwner {
                return childOwner
            } else {
                return "none"
            }
        }
    }
    
//    func changeStatus(to: ) {
//
//    }
    
    func assign(to: Int) {
        
    }
}
