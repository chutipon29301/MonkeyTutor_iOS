//
//  TaskDetailTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 26/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import PopupDialog
import EZLoadingActivity
import TCPickerView

class TaskDetailTableViewController: UITableViewController, RequestResultDelegate, TCPickerViewDelegate {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTag: UILabel!
    @IBOutlet weak var taskDuedate: UILabel!
    @IBOutlet weak var taskOwner: UILabel!
    @IBOutlet weak var taskDetail: UITextView!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yy"
        
        TutorDataManager.getInstance().fetch()
        
        taskName.text = task.title
        taskOwner.text = task.createBy
        taskDetail.text = task.detail
        if let dueDate = task.dueDate {
            taskDuedate.text = "\(formatter.string(from: dueDate))"
        }else {
            taskDuedate.text = "None"
        }
        if task.tags.count > 0 {
            taskTag.text = task.tags[0]
        }else {
            taskTag.text = "Any"
        }
    }
    
    @IBAction func doneBtnClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assignBtnClick(_ sender: UIButton) {
        let title = "Change status"
        let message = "Select task status"
        
        let popup = PopupDialog(title: title, message: message)
        
        let todoBtn = DefaultButton(title: "TODO") {
            NetworkManager.getInstance().changeStatus(taskID: self.task.id, taskStatus: TaskStatus.todo, callback: self)
            EZLoadingActivity.show("Loading", disableUI: true)
        }
        let inProgessBtn = DefaultButton(title: "In Progress") {
            NetworkManager.getInstance().changeStatus(taskID: self.task.id, taskStatus: TaskStatus.onProcess, callback: self)
            EZLoadingActivity.show("Loading", disableUI: true)
        }
        let assignBtn = DefaultButton(title: "Assign") {
            let picker = TCPickerView()
            picker.title = "Tutors"
            let values = TutorDataManager.getInstance().getTutorList().map { TCPickerView.Value(title: $0.nicknameEn) }
            picker.values = values
            picker.delegate = self
            picker.selection = .single
            picker.completion = { (selectedIndexes) in
                var tutorID = [Int]()
                for i in selectedIndexes {
                    tutorID.append(TutorDataManager.getInstance().getTutorList()[i].id)
                }
                NetworkManager.getInstance().assignTask(taskID: self.task.id, tutorID: tutorID, callback: self)
                EZLoadingActivity.show("Loading", disableUI: true)
            }
            picker.show()
        }
        let doneBtn = DefaultButton(title: "Done") {
            NetworkManager.getInstance().changeStatus(taskID: self.task.id, taskStatus: TaskStatus.done, callback: self)
            EZLoadingActivity.show("Loading", disableUI: true)
        }
        popup.addButtons([todoBtn, inProgessBtn, assignBtn, doneBtn])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func onRequestResultDone(isSuccess: Bool) {
        if isSuccess{
            EZLoadingActivity.hide(true, animated: true)
            self.dismiss(animated: true, completion: nil)
        }else {
            EZLoadingActivity.hide(false, animated: true)
            let alert = UIAlertController(title: "Alert", message: "Unable to procress request, please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func pickerView(_ pickerView: TCPickerView, didSelectRowAtIndex index: Int) {
    }
    
}
