//
//  ChangeWorkflowStatusViewController.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

protocol ChangeWorkflowStatusDelegate {
    func changeStatus(status: Workflow.Status)
}

class ChangeWorkflowStatusViewController: UIViewController {
    
    @IBAction func noteBtnTapped(_ sender: Any) {
        changeStatus(status: .note)
    }
    
    @IBAction func todoBtnTapped(_ sender: Any) {
        changeStatus(status: .todo)
    }
    
    @IBAction func inProgressBtnTapped(_ sender: Any) {
        changeStatus(status: .inprogress)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        changeStatus(status: .done)
    }
    
    private func changeStatus(status: Workflow.Status) {
        if let parent = presentingViewController as? ChangeWorkflowStatusDelegate {
            dismiss(animated: true, completion: { parent.changeStatus(status: status) })
        }
    }
}
