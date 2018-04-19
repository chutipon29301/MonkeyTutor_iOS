//
//  AssignWorkflowViewController.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

protocol AssignWorkflowDelegate {
    func assignWorkflow(tutor: Tutor)
}

class AssignWorkflowViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TutorUpdateResult {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
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
        if let parent = presentingViewController as? AssignWorkflowDelegate {
            dismiss(animated: true, completion: {
                parent.assignWorkflow(tutor: TutorManager.shared.tutors[self.pickerView.selectedRow(inComponent: 0)])
            })
        }
    }
}
