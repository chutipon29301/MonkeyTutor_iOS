//
//  WorkflowTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 14/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class WorkflowTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkflowManager.shared.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(self.update(_:)), for: .valueChanged)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        presentDialog(NewWorkflowViewController(), size: nil, completion: nil)
    }
    
    @objc private func update(_ sender: Any) {
        WorkflowManager.shared.delegate = self
        WorkflowManager.shared.updateWorkflow()
    }
    
}

extension WorkflowTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Workflow.Status.allValues.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workflowCell") as! WorkflowTableViewCell
        let status = Workflow.Status.allValues[indexPath.row]
        let workflows = WorkflowManager.shared.workflows.filterWith(status: status)
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: 252/255, green: 201/255, blue: 246/255, alpha: 1)
        }
        cell.title.text = status.value()
        cell.workCount.text = String(workflows.count) + " remaining"
        cell.hbCount.text = String(workflows.countTags(.hybrid))
        cell.appCount.text = String(workflows.countTags(.app))
        cell.testCount.text = String(workflows.countTags(.test))
        cell.webCount.text = String(workflows.countTags(.web))
        cell.designCount.text = String(workflows.countTags(.design))
        cell.otherCount.text = String(workflows.countTags(.other))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWorkflowList", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("showWorkflowList", let destination):
            if let destination = destination as? WorkflowListTableViewController, let indexPath = sender as? IndexPath {
                destination.status = Workflow.Status.allValues[indexPath.row]
            }
            break
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension WorkflowTableViewController: WorkflowUpdaterDelegate {
    
    func workflowDataUpdate(success :Bool) {
        tableView.refreshControl?.endRefreshing()
        if success {
            self.tableView.reloadData()
        } else {
            presentAlertDialog(text: "An error occured, please try again later")
        }
    }
    
}

class WorkflowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var workCount: UILabel!
    @IBOutlet weak var hbCount: UILabel!
    @IBOutlet weak var appCount: UILabel!
    @IBOutlet weak var testCount: UILabel!
    @IBOutlet weak var webCount: UILabel!
    @IBOutlet weak var designCount: UILabel!
    @IBOutlet weak var otherCount: UILabel!
    
}
