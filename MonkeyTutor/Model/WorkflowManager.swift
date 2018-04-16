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
    func workflowDataUpdate()
}

class WorkflowManager {
    
    static let shared = WorkflowManager()
    
    static let status = [
        (label: "Note", value: "note"),
        (label: "Todo", value: "todo"),
        (label: "In progress", value: "inprogress"),
        (label: "Assign", value: "assign"),
        (label: "Done", value: "done"),
        (label: "Complete", value: "complete")
    ]
    
    static let tags = [
        "hybrid",
        "app",
        "test",
        "web",
        "design",
        "other"
    ]
    
    
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
    
    func workflowFilterWith(indexPath: IndexPath) -> [Workflow] {
        return _workflows.filter { $0.status == WorkflowManager.status[indexPath.row].value }
    }
    
    func updateWorkflow() {
        subscription = NetworkManager.shared.listWorkflow().subscribe {
            switch $0 {
            case.next(let value):
                self._workflows = ObjectMapper.mapWorkflowResult(value)
                self._delegate?.workflowDataUpdate()
                break
            case .error(let error):
                print(error)
                break
            case .completed:
                break
            }
        }
    }
    
    func cancelUpdate() {
        subscription?.dispose()
    }
    
}

class Workflow {
    private var _title: String!
    private var _nodeID: String!
    private var _timestamp: Date!
    private var _createdBy: Int!
    private var _duedate: Date?
    private var _status: String!
    private var _owner: Int!
    private var _parent: String!
    private var _ancestors: [String]!
    private var _subtitle: String!
    private var _detail: String!
    private var _tag: String!
    
    init(title: String, id: String, timestamp: Date, createdBy: Int, duedate: Date?, status: String, owner: Int, parent: String, ancestors: [String], subtitle: String, detail: String, tag: String) {
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
    }
    
    var status: String {
        get {
            return _status
        }
    }
    
    var tag: String {
        get {
            return _tag
        }
    }
}