//
//  TaskTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import expanding_collection
import BulletinBoard
import EZLoadingActivity

class TaskTableViewController: ExpandingTableViewController, RequestResultDelegate, FetchResultDelegate {
    
    var selectedStatus: TaskStatus!
    var taskID: String?
    
    lazy var bulletinManager: BulletinManager = {
        let page = PageBulletinItem(title: "Delete")
        page.descriptionText = "Do you want to delete task?"
        page.actionButtonTitle = "Delete"
        page.alternativeButtonTitle = "Cancel"
        page.actionHandler = { (item: PageBulletinItem) in
            if let id = self.taskID{
                NetworkManager.getInstance().deleteTask(taskID: id, callback: self.self)
                EZLoadingActivity.show("Deleting task", disableUI: true)
            }
        }
        page.interfaceFactory.tintColor = .red
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.dismissBulletin()
        }
        page.isDismissable = true
        let rootItem: BulletinItem = page
        return BulletinManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popTransitionAnimation()
    }
    
    func dismissBulletin() {
        bulletinManager.dismissBulletin()
    }
    
    func onRequestResultDone(isSuccess: Bool) {
        if isSuccess {
            EZLoadingActivity.hide(true, animated: true)
            self.dismissBulletin()
            CollectionViewTaskManager.getInstance().fetch(callback: self)
        }else {
            EZLoadingActivity.hide(false, animated: true)
            self.dismissBulletin()
            let alert = UIAlertController(title: "Warning", message: "Can't delete task, not authorize", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func onFetchResultComplete() {
        tableView?.reloadData()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskID = CollectionViewTaskManager.getInstance().getTaskWith(status: selectedStatus)[indexPath.row].id
            bulletinManager.prepare()
            bulletinManager.presentBulletin(above: self)
        }
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
