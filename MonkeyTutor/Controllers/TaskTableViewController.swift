//
//  TaskTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import expanding_collection

class TaskTableViewController: ExpandingTableViewController {
    
    var selectedStatus: TaskStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popTransitionAnimation()
    }
}

extension TaskTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectionViewTaskManager.getInstance().getTaskWith(status: selectedStatus).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskDetailCell") as! TaskTableViewCell
        let taskInfo = CollectionViewTaskManager.getInstance().getTaskWith(status: selectedStatus)[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yy"
        cell.taskNameLabel.text = taskInfo.title
        cell.creatorNameLabel.text = taskInfo.createBy
        if let dueDate = taskInfo.dueDate {
            cell.dueDateLabel.text = "Due date: \(formatter.string(from: dueDate))"
        }else {
            cell.dueDateLabel.text = "Due date: None"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
}
