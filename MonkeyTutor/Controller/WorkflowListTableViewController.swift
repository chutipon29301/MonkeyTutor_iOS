//
//  WorkflowListTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class WorkflowListTableViewController: UITableViewController, WorkflowUpdaterDelegate, UISearchResultsUpdating {
    
    var status: Workflow.Status!
    private var workflows: [Workflow] = []
    private var selectedIndex: IndexPath?
    private var loadingViewController: LoadingViewController?
    let searchController = UISearchController(searchResultsController: nil)
    let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = status.value()
        tableView.refreshControl?.addTarget(self, action: #selector(self.update(_:)), for: .valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Workflow"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchController.isActive || searchController.searchBar.text == "" {
            workflows = WorkflowManager.shared.workflows.filterWith(status: status)
            workflows.sort(by: { $0.title < $1.title })
        }
        return workflows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workflowListCell") as! WorkflowListTableViewCell
        let workflow = workflows[indexPath.row]
        cell.title.text = workflow.title
        cell.subtitle.text = workflow.subtitle
        cell.duedate.text = workflow.duedateString
        if status != .complete {
            if let duedate = workflow.duedate {
                if duedate < today {
                    cell.duedate.textColor = UIColor.red
                } else {
                    cell.duedate.textColor = UIColor.black
                }
            } else {
                cell.duedate.textColor = UIColor.black
            }
        }
        cell.status.text = workflow.childStatus.value()
        cell.assign.text = workflow.childOwner
        cell.tutorColor.backgroundColor = TutorColorManager.shared.getTutorColor(from: workflow.childOwner)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDialog(WorkflowDetailViewController(workflow: workflows[indexPath.row]), size: nil, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {
            _,_ in
            
            let alert = UIAlertController(title: "Alert", message: "Do you want to delete this task?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {
                _ in
                self.loadingViewController = LoadingViewController()
                if let view = self.loadingViewController {
                    self.workflows[indexPath.row].delegate = self
                    WorkflowManager.shared.remove(workflow: self.workflows[indexPath.row].delete())
                    self.presentDialog(view, size: CGSize(width: 300, height: 300), completion: nil)
                    self.update(0)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        
        let duplicate = UITableViewRowAction(style: .normal, title: "Duplicate") { _, _ in
            let view = NewWorkflowViewController()
            view.sampleWorkflow = self.workflows[indexPath.row]
            self.presentDialog(view, size: nil, completion: nil)
        }
        
        if workflows[indexPath.row].canDelete {
            return [delete, duplicate]
        } else {
            return [duplicate]
        }
    }
    
    @objc private func update(_ sender: Any) {
        WorkflowManager.shared.delegate = self
        WorkflowManager.shared.updateWorkflow()
        tableView.reloadData()
    }
    
    func changeStatus(status: Workflow.Status) {
        loadingViewController = LoadingViewController()
        if let indexPath = selectedIndex,
            let view = loadingViewController {
            workflows[indexPath.row].changeStatus(status)
            presentDialog(view, size: CGSize(width: 300, height: 300), completion: nil)
        }
    }
    
    func workflowDataUpdate(success: Bool) {
        tableView.refreshControl?.endRefreshing()
        loadingViewController?.dismiss(animated: true, completion: nil)
        if success {
            tableView.reloadData()
        } else {
            presentAlertDialog(text: "An error occured, please try again")
        }
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        workflows = WorkflowManager.shared.workflows.filterWith(status: status)
        workflows.sort(by: { $0.title < $1.title })
        if searchController.isActive {
            workflows = workflows.filter {
                let title = $0.title.lowercased().range(of: searchController.searchBar.text?.lowercased() ?? "")
                let ownerName = $0.childOwner.lowercased().range(of: searchController.searchBar.text?.lowercased() ?? "")
                return title != nil || ownerName != nil
            }
        }
        tableView.reloadData()
    }
}

class WorkflowListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var assign: UILabel!
    @IBOutlet weak var tutorColor: UIView!
}
