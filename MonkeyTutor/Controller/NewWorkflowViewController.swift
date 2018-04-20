//
//  NewWorkflowViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class NewWorkflowViewController: UIViewController {
    
    @IBOutlet weak var workflowTitle: MDCTextField!
    @IBOutlet weak var subtitle: MDCTextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tag: UILabel!
    @IBOutlet weak var detail: UITextView!
    private var currentDate: Date?
    private var loadingViewController: LoadingViewController?
    private var workflowID: String?
    var sampleWorkflow: Workflow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(outsideTap)
        
        if let workflow = sampleWorkflow {
            workflowTitle.text = workflow.title
            subtitle.text =  workflow.subtitle
            tag.text = workflow.tag.rawValue
            date.text = workflow.duedateString
            currentDate = workflow.duedate
            detail.text = workflow.detail
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTagBtnTapped(_ sender: Any) {
        presentDialog(TagSelectViewController(), size: CGSize(width: 300, height: 300), completion: nil)
    }
    
    @IBAction func dateSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            presentDialog(DateSelectViewController(), size: CGSize(width: 300, height: 300), completion: nil)
        } else {
            date.text = "none"
            currentDate = nil
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if let title = workflowTitle.text, let subtitle = subtitle.text, let tag = tag.text, let detail = detail.text {
            loadingViewController = LoadingViewController()
            if let view = loadingViewController {
                presentDialog(view, size: CGSize(width: 300, height: 200), completion: {
                    WorkflowManager.shared.createWorkflow(title: title, subtitle: subtitle, duedate: self.currentDate, tag: tag, detail: detail, delegate: self)
                })
            }
        } else {
            presentAlertDialog(text: "Please fill all the field")
        }
    }
}

extension NewWorkflowViewController: TagSelectorDelegate {
    
    func setTag(tag: Workflow.Tags) {
        self.tag.text = tag.rawValue
    }
    
}

extension NewWorkflowViewController: DateSelectorDelegate {
    
    func setDate(date: Date) {
        self.date.text = date.dateString
        currentDate = date
    }
    
}

extension NewWorkflowViewController: WorflowCreateResultDelegate {
    
    func workflowCreated(id: String?) {
        loadingViewController?.dismiss(animated: true, completion: {
            if let id = id,
                let parent = self.presentingViewController {
                self.workflowID = id
                self.dismiss(animated: true, completion: {
//                    create temp workflow
                    let workflow = Workflow(title: "", id: id, timestamp: Date(), createdBy: 0, duedate: nil, status: .none, owner: 0, parent: "", ancestors: [], subtitle: "", detail: "", tag: .other, childStatus: nil, childOwner: nil, canDelete: false)
                    parent.presentDialog(AssignWorkflowViewController(workflow: workflow), size: CGSize(width: 300, height: 300), completion: nil)
                })
            } else {
                self.presentAlertDialog(text: "An error occured, please try again later")
            }
        })
    }
    
}
