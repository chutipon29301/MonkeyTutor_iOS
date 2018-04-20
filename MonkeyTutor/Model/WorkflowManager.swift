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

protocol WorflowCreateResultDelegate {
    func workflowCreated(id: String?)
}

class WorkflowManager {
    
    static let shared = WorkflowManager()
    
    var workflows: [Workflow] = []
    private var subscription: Disposable?
    var delegate: WorkflowUpdaterDelegate?
    
    private init() {
        updateWorkflow()
    }
    
    func updateWorkflow() {
        subscription = NetworkManager.shared.listWorkflow().subscribe {
            switch $0 {
            case.next(let value):
                self.workflows = value.workflows
                self.delegate?.workflowDataUpdate(success: true)
                break
            case .error(_):
                self.delegate?.workflowDataUpdate(success: false)
                break
            case .completed:
                break
            }
        }
    }
    
    func cancel() {
        subscription?.dispose()
    }
    
    func createWorkflow(title: String, subtitle: String, duedate: Date?, tag: String, detail: String, delegate: WorflowCreateResultDelegate?) {
        subscription = NetworkManager.shared.createWorkflow(title: title, subtitle: subtitle, duedate: duedate, tag: tag, detail: detail).subscribe {
            switch $0 {
            case .next(let value):
                if let delegate = delegate {
                    delegate.workflowCreated(id: value.nodeID)
                }
                break
            case .error(_):
                if let delegate = delegate {
                    delegate.workflowCreated(id: nil)
                }
                break
            case .completed:
                break
            }
        }
    }
    
    func remove(workflow: Workflow) {
        print(self.workflows.count)
        self.workflows.remove(at: self.workflows.index(where: { $0 == workflow})!)
        print(self.workflows.count)
    }
    
}

class Workflow: Equatable {
    
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
    private var _canDelete: Bool!
    
    private var subscription: Disposable?
    
    var delegate: WorkflowUpdaterDelegate?
    
    init(title: String, id: String, timestamp: Date, createdBy: Int, duedate: Date?, status: Status, owner: Int, parent: String, ancestors: [String], subtitle: String, detail: String, tag: Tags, childStatus: Status?, childOwner: String?, canDelete: Bool) {
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
        _canDelete = canDelete
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
    
    var duedate: Date? {
        get {
            return _duedate
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
            return _childOwner ?? "none"
        }
    }
    
    var canDelete: Bool {
        get {
            return _canDelete
        }
    }
    
    static func == (lhs: Workflow, rhs: Workflow) -> Bool {
        return lhs._nodeID == rhs._nodeID
    }
    
    
    func changeStatus(_ to: Status) {
        switch to {
        case .note:
            subscription = NetworkManager.shared.workflowNote(workflowID: _nodeID).subscribe {
                switch $0 {
                case .next(let value):
                    self.delegate?.workflowDataUpdate(success: value.responseOK)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }
            break
        case .todo:
            subscription = NetworkManager.shared.workflowTodo(workflowID: _nodeID).subscribe {
                switch $0 {
                case .next(let value):
                    self.delegate?.workflowDataUpdate(success: value.responseOK)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }
            break
        case .inprogress:
            subscription = NetworkManager.shared.workflowInProgress(workflowID: _nodeID).subscribe {
                switch $0 {
                case .next(let value):
                    self.delegate?.workflowDataUpdate(success: value.responseOK)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }
            break
        case .done:
            subscription = NetworkManager.shared.workflowDone(workflowID: _nodeID).subscribe {
                switch $0 {
                case .next(let value):
                    self.delegate?.workflowDataUpdate(success: value.responseOK)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
            }
            break
        default:
            break
        }
    }
    
    func assign(to owner: Int, subtitle: String?, detail: String?, duedate: Date?) {
        subscription = NetworkManager.shared.assign(
            workflowID: _nodeID,
            to: owner,
            subtitle: subtitle,
            detail: detail,
            duedate: duedate).subscribe{
                switch $0 {
                case .next(let value):
                    self.delegate?.workflowDataUpdate(success: value.responseOK)
                    break
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
    }
    
    func delete() -> Workflow{
        subscription = NetworkManager.shared.workflowDelete(workflowID: _nodeID).subscribe {
            switch $0 {
            case .next(let value):
                self.delegate?.workflowDataUpdate(success: value.responseOK)
                break
            case .error(_):
                break
            case .completed:
                break
            }
        }
        return self
    }
}
