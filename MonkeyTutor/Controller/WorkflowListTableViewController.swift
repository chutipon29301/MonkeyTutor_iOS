//
//  WorkflowListTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class WorkflowListTableViewController: UITableViewController {
    
    var selectedIndexPath: IndexPath!
    private var workflows: [Workflow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workflows = WorkflowManager.shared.workflowFilterWith(indexPath: selectedIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workflows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workflowListCell") as! WorkflowListTableViewCell
        let workflow = workflows[indexPath.row]
        cell.title.text = workflow.title
        cell.subtitle.text = workflow.subtitle
        cell.duedate.text = workflow.duedateString
        cell.status.text = workflow.childStatus
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class WorkflowListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var status: UILabel!
}
