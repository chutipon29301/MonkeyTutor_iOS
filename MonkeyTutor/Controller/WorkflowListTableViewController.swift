//
//  WorkflowListTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class WorkflowListTableViewController: UITableViewController {
    
    var status: Workflow.Status!
    private var workflows: [Workflow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = status.value()
        workflows = WorkflowManager.shared.workflows.filterWith(status: status)
        
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
        cell.status.text = workflow.childStatus.value()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDialog(WorkflowDetailViewController(workflow: workflows[indexPath.row]), size: nil, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
}

class WorkflowListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var status: UILabel!
}
