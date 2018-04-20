//
//  AssignWorkflowDetailViewController.swift
//  MonkeyTutor
//
//  Created by admin on 18/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

//protocol AssignWorkflowDetailDelegate {
//    func assignWorkflowDetail(subtitle: String?, detail: String?, date: Date?, tutor: Tutor)
//}

class AssignWorkflowDetailViewController: UIViewController, WorkflowUpdaterDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: MDCTextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detail: UITextView!
    private var currentDate: Date?
    private var loadingViewController: LoadingViewController?
    private var tutor: Tutor?
    private var workflow: Workflow?
    
    convenience init(tutor: Tutor, workflow: Workflow) {
        self.init()
        self.tutor = tutor
        self.workflow = workflow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = tutor?.nicknameEn
    }
    
    @IBAction func dateSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            presentDialog(DateSelectViewController(), size: CGSize(width: 300, height: 300), completion: nil)
        } else {
            date.text = "none"
            currentDate = nil
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assignBtnTapped(_ sender: Any) {
//        if let parent = presentingViewController as? AssignWorkflowDetailDelegate,
//            let tutor = tutor
//        {
//            dismiss(animated: true, completion: {
//                parent.assignWorkflowDetail(subtitle: self.subtitle.text, detail: self.detail.text, date: self.currentDate, tutor: tutor)
//            })
//        }
        loadingViewController = LoadingViewController()
        if let tutor = tutor,
            let workflow = workflow,
            let view = loadingViewController {
            workflow.delegate = self
            presentDialog(view, size: CGSize(width: 300, height: 300), completion: {
                workflow.assign(to: tutor.id, subtitle: self.subtitle.text, detail: self.detail.text, duedate: self.currentDate)
            })
        }
    }
    
    func workflowDataUpdate(success: Bool) {
        if success {
            loadingViewController?.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            presentAlertDialog(text: "An error occured, please try again")
        }
    }
}

extension AssignWorkflowDetailViewController: DateSelectorDelegate {
    
    func setDate(date: Date) {
        self.date.text = date.dateString
        currentDate = date
    }
    
}
