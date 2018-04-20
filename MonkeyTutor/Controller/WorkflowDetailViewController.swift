//
//  WorkflowDetailViewController.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class WorkflowDetailViewController: UIViewController, WorkflowUpdaterDelegate, ChangeWorkflowStatusDelegate {
    
    @IBOutlet weak var workflowTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var tag: UILabel!
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var assign: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var detail: UITextView!
    
    private var _workflow: Workflow?
    private var loadingViewController: LoadingViewController?
    
    convenience init(workflow: Workflow) {
        self.init()
        _workflow = workflow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let workflow = _workflow {
            workflowTitle.text = workflow.title
            subtitle.text = workflow.subtitle
            tag.text = workflow.tag.value()
            duedate.text = workflow.duedateString
            assign.text = workflow.childOwner
            detail.text = workflow.detail
            status.text = workflow.childStatus.value()
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func statusBtnTapped(_ sender: Any) {
        presentDialog(ChangeWorkflowStatusViewController(), size: CGSize(width: 300, height: 250), completion: nil)
    }
    
    @IBAction func assignBtnTapped(_ sender: Any) {
        presentDialog(AssignWorkflowViewController(), size: CGSize(width: 300, height: 300), completion: nil)
    }
    
    func changeStatus(status: Workflow.Status) {
        loadingViewController = LoadingViewController()
        if let view = loadingViewController {
            presentDialog(view, size: CGSize(width: 300, height: 300), completion: {
                self._workflow?.delegate = self
                self._workflow?.changeStatus(status)
            })
        }
    }
    
    func workflowDataUpdate(success: Bool) {
        loadingViewController?.dismiss(animated: true, completion: {
            if success {
                WorkflowManager.shared.updateWorkflow()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.presentAlertDialog(text: "An error occured, please try again later")
            }
        })
    }
    
    func assignWorkflowDetail(subtitle: String?, detail: String?, date: Date?, tutor: Tutor) {
        loadingViewController = LoadingViewController()
        if let view = loadingViewController {
            presentDialog(view, size: CGSize(width: 300, height: 300), completion: {
                self._workflow?.delegate = self
                self._workflow?.assign(to: tutor.id, subtitle: subtitle, detail: detail, duedate: date)
            })
        }
    }
}
