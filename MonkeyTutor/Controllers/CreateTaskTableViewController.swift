//
//  CreateTaskViewController.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import Material
import EZLoadingActivity

class CreateTaskTableViewController: UITableViewController, RequestResultDelegate {
    
    var isSetDueDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func cancleBtnPress(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnPress(_ sender: UIBarButtonItem) {
//        if let taskNameText = taskName.text, let taskTagText = tag.text, let taskDetailText = taskDetail.text {
//            if (taskNameText != "" && taskTagText != "" && taskDetailText != ""){
//                NetworkManager.getInstance().addTask(taskName: taskNameText, taskDetail: taskDetailText, taskTag: [taskTagText], taskDueDate: nil, callback: self)
//                EZLoadingActivity.show("Adding task", disableUI: true)
//            }else if (taskNameText != "" && taskDetailText != ""){
//                NetworkManager.getInstance().addTask(taskName: taskNameText, taskDetail: taskDetailText, taskTag: nil, taskDueDate: nil, callback: self)
//                EZLoadingActivity.show("Adding task", disableUI: true)
//            }else {
//                var showText: String?
//                if taskNameText == "" && taskDetailText == ""{
//                    showText = "Please fill task name and task detail"
//                }else if (taskNameText == ""){
//                    showText = "Please fill task name"
//                }else if (taskDetailText == ""){
//                    showText = "Please fill task detail"
//                }
//                if let text = showText{
//                    let alert = UIAlertController(title: "Aleart", message: text, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                    present(alert, animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    func onRequestResultDone(isSuccess: Bool) {
        if isSuccess {
            EZLoadingActivity.hide(true, animated: true)
            self.dismiss(animated: true, completion: nil)
        }else {
            EZLoadingActivity.hide(false, animated: true)
            let alert = UIAlertController(title: "Alert", message: "Can't add task, please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dueDateToggle(_ sender: UISwitch) {
        isSetDueDate = sender.isOn
        tableView.reloadData()
    }
}

extension CreateTaskTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0...1:
            return 70
        case 2:
            return 48
        case 3:
            if isSetDueDate {
                return 160
            }else {
                return 320
            }
        case 4:
            return 320
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isSetDueDate) ? 5 : 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "taskTitleTableViewCell")!
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "taskTagTableViewCell")!
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "taskDueDateSelectorTableViewCell")!
        case 3:
            if isSetDueDate {
                return tableView.dequeueReusableCell(withIdentifier: "taskDatePickerTableViewCell")!
            }else {
                return tableView.dequeueReusableCell(withIdentifier: "taskDetailTableViewCell")!
            }
        case 4:
            return tableView.dequeueReusableCell(withIdentifier: "taskDetailTableViewCell")!
        default:
            return UITableViewCell()
        }
    }
}

class CreateTaskTitleFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTitle: TextField!
}

class CreateTaskTagFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTag: TextField!
}

class CreateTaskSetDueDateSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var dueDateSwitchChange: UISwitch!
}

class CreateTaskDateSelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!
}

class CreateTaskDetailFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var taskDetail: TextView!
}
