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
            cell.dueDateLabel.text = "\(formatter.string(from: dueDate))"
        } else {
            cell.dueDateLabel.text = "Due date: None"
        }
        if taskInfo.childStatus == TaskStatus.none.rawValue{
            cell.childStatusLabel.text = ""
        } else {
            let label = ["TODO", "In Progress", "Assign", "Done"]
            cell.childStatusLabel.text = label[taskInfo.childStatus]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTaskDetail", sender: indexPath)
    }
}


extension TaskTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showTaskDetail":
                if let destination = segue.destination.childViewControllers[0] as? TaskDetailTableViewController,
                    let indexPath = sender as? IndexPath{
                    destination.task = CollectionViewTaskManager.getInstance().getTaskWith(status: selectedStatus)[indexPath.row]
                }
                break
            default:
                break
            }
        }
    }
}
class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var childStatusLabel: UILabel!
    
}
