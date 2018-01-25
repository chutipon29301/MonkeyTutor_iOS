//
//  ColectionViewTaskManager.swift
//  MonkeyTutor
//
//  Created by admin on 24/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol FetchResultDelegate {
    func onFetchResultComplete()
}

class CollectionViewTaskManager: ListTaskResultDelegate {
    
    private var callback: FetchResultDelegate?
    private var taskList = [Task]()
    
    private static var sharedCollectionViewTaskManager: CollectionViewTaskManager = {
        let collectionViewTaskManager = CollectionViewTaskManager()
        return collectionViewTaskManager
    }()
    
    class func getInstance() -> CollectionViewTaskManager{
        return sharedCollectionViewTaskManager
    }
    
    func fetch(callback: FetchResultDelegate?) {
        self.callback = callback
        NetworkManager.getInstance().listTask(callback: self)
    }
    
    func onListTaskDone(data: Any?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let existData = data {
            let jsonData = JSON(existData)
            let tasks = JSON(jsonData["tasks"])
            for ( _, subJson):(String, JSON) in tasks {
                let task = Task()
                task.id = subJson["taskID"].stringValue
                task.createOn = dateFormatter.date(from: subJson["createOn"].stringValue)
                task.lastModified = dateFormatter.date(from: subJson["lastModified"].stringValue)
                task.title = subJson["title"].stringValue
                task.detail = subJson["detail"].stringValue
                task.owner = subJson["owner"].stringValue
                task.createBy = subJson["createBy"].stringValue
                task.modifyBy = subJson["modifyBy"].stringValue
                if (subJson["parent"].null != nil)  {
                    task.parent = subJson["parent"].stringValue
                }
                task.status = subJson["status"].intValue
                task.order = subJson["order"].intValue
                task.remark = subJson["remark"].stringValue
                task.hasDueDate = subJson["hasDueDate"].boolValue
                for ( _, ancestor): (String, JSON) in subJson["ancestors"]{
                    task.ancestors.append(ancestor.stringValue)
                }
                for ( _, tag): (String, JSON) in subJson["tags"]{
                    task.tags.append(tag.stringValue)
                }
                if !taskList.contains{ $0.id == task.id } {
                    taskList.append(task)
                }
            }
            if let delegate = callback {
                delegate.onFetchResultComplete()
            }
        }
    }
    
    func getTask() -> [Task] {
        return taskList
    }
    
    func getTaskStatusCount() -> [(String, Int, TaskStatus)] {
        return [
            ("TODO", taskList.filter{ $0.status == TaskStatus.todo.rawValue}.count, TaskStatus.todo),
            ("In Procress", taskList.filter{ $0.status == TaskStatus.onProcess.rawValue}.count, TaskStatus.onProcess),
            ("Assign", taskList.filter{ $0.status == TaskStatus.assign.rawValue}.count, TaskStatus.assign),
            ("Done", taskList.filter{ $0.status == TaskStatus.done.rawValue}.count, TaskStatus.done)
        ]
    }
    
    func getTaskWith(status: TaskStatus) -> [Task] {
        return taskList.filter{ $0.status == status.rawValue}
    }
}
