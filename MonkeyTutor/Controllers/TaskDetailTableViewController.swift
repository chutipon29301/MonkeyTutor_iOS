//
//  TaskDetailTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 26/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTag: UILabel!
    @IBOutlet weak var taskDuedate: UILabel!
    @IBOutlet weak var taskOwner: UILabel!
    @IBOutlet weak var taskDetail: UITextView!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yy"
        
        taskName.text = task.title
        taskOwner.text = task.createBy
        taskDetail.text = task.detail
        if let dueDate = task.dueDate {
            taskDuedate.text = "\(formatter.string(from: dueDate))"
        }else {
            taskDuedate.text = "None"
        }
        if task.tags.count > 0 {
            taskTag.text = task.tags[0]
        }else {
            taskTag.text = "Any"
        }
    }
    
    @IBAction func doneBtnClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
