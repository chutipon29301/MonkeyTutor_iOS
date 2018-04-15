//
//  WorkflowTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 14/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs

class WorkflowTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkflowManager.shared.delegate = self
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let dialogTransistionController = MDCDialogTransitionController()
        let newWorkflowViewController = NewWorkflowViewController()
        newWorkflowViewController.modalPresentationStyle = .custom
        newWorkflowViewController.transitioningDelegate = dialogTransistionController
        present(newWorkflowViewController, animated: true, completion: nil)
    }
    
}

extension WorkflowTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkflowManager.status.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workflowCell") as! WorkflowTableViewCell
        cell.title.text = WorkflowManager.status[indexPath.row].label
        let workflows = WorkflowManager.shared.workflowFilterWith(indexPath: indexPath)
        cell.workCount.text = String(workflows.count) + " remaining"
        cell.hbCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[0] }.count)
        cell.appCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[1] }.count)
        cell.testCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[2] }.count)
        cell.webCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[3] }.count)
        cell.designCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[4] }.count)
        cell.otherCount.text = String(workflows.filter { $0.tag == WorkflowManager.tags[5] }.count)
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
                destination.title = WorkflowManager.status[indexPath.row].label
            }
            break
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension WorkflowTableViewController: WorkflowUpdaterDelegate {
    
    func workflowDataUpdate() {
        self.tableView.reloadData()
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
