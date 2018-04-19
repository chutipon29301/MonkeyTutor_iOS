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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(outsideTap)
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
            print(id)
            if let id = id {
                self.workflowID = id
                self.presentDialog(AssignWorkflowViewController(), size: CGSize(width: 300, height: 300), completion: nil)
//                self.dismiss(animated: true, completion: {
//                    WorkflowManager.shared.updateWorkflow()
//                })
            } else {
                self.presentAlertDialog(text: "An error occured, please try again later")
            }
        })
    }
    
}

extension NewWorkflowViewController: AssignWorkflowDelegate {
    func assignWorkflow(tutor: Tutor) {
        presentDialog(AssignWorkflowDetailViewController(tutor: tutor), size: nil, completion: nil)
    }
}

extension NewWorkflowViewController: AssignWorkflowDetailDelegate {
    func assignWorkflowDetail(subtitle: String?, detail: String?, date: Date?, tutor: Tutor) {
        loadingViewController = LoadingViewController()
        if let view = loadingViewController {
            presentDialog(view, size: CGSize(width: 300, height: 300), completion: {
                if let id = self.workflowID {
                    let _ = NetworkManager.shared.assign(workflowID: id, to: tutor.id, subtitle: subtitle, detail: detail, duedate: nil).subscribe{
                        switch $0 {
                        case .next(let value):
                            view.dismiss(animated: true, completion: nil)
                            if value.responseOK {
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.presentAlertDialog(text: "An error occured, please try again later")
                            }
                            break
                        case .error(_):
                            self.presentAlertDialog(text: "An error occured, please try again later")
                            break
                        case .completed:
                            break
                        }
                    }
                }
//                self._workflow?.delegate = self
//                self._workflow?.assign(to: tutor.id, subtitle: subtitle, detail: detail, duedate: date)
            })
        }
    }
}

//extension NewWorkflowViewController: WorkflowUpdateResultDelegate {
//
//    func workflowUpdated(workflow: Workflow?) {
//        loadingViewController?.dismiss(animated: true, completion: {
//            //            TODO: Handle assign after create workflow
//            if let workflow = workflow {
//                self.dismiss(animated: true, completion: {
//                    WorkflowManager.shared.updateWorkflow()
//                })
//            } else {
//                self.presentAlertDialog(text: "An error occured, please try again later")
////                self.presentDialog(AlertViewController(labelWith: "An error occured, please try again later"), size: CGSize(width: 300, height: 250), completion: nil)
//            }
//        })
//    }
//
//}
