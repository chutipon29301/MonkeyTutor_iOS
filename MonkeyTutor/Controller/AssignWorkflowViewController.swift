//
//  AssignWorkflowViewController.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit


class AssignWorkflowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TutorUpdateResult {
    
    @IBOutlet weak var pickerView: UIPickerView!
    private var workflow: Workflow?
    
    convenience init(workflow: Workflow) {
        self.init()
        self.workflow = workflow
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TutorManager.shared.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TutorManager.shared.tutors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TutorManager.shared.tutors[row].nicknameEn
    }
    
    func tutorDataUpdate(success: Bool) {
        if success {
            pickerView.reloadAllComponents()
        } else {
            presentAlertDialog(text: "An error occured, please try again later")
        }
    }
    
    @IBAction func assignBtnTapped(_ sender: Any) {
        if let parent = presentingViewController,
            let workflow = workflow {
            dismiss(animated: true, completion: {
                parent.presentDialog(AssignWorkflowDetailViewController(tutor: TutorManager.shared.tutors[self.pickerView.selectedRow(inComponent: 0)], workflow: workflow), size: nil, completion: nil)
            })
        }
    }
}
