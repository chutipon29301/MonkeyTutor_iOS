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
import TCPickerView

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
        var taskName: String?
        var taskTag: String?
        var taskDueDate: Date?
        var taskDetail: String?
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            switch i {
            case 0:
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CreateTaskTitleFieldTableViewCell
                taskName = cell.taskTitle.text
                break
            case 1:
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CreateTaskTagFieldTableViewCell
                taskTag = cell.taskTag.text
                break
            case 3:
                if isSetDueDate {
                    let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CreateTaskDateSelectorTableViewCell
                    taskDueDate = cell.datePicker.date
                    break
                }else {
                    let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CreateTaskDetailFieldTableViewCell
                    taskDetail = cell.taskDetail.text
                    break
                }
            case 4:
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CreateTaskDetailFieldTableViewCell
                taskDetail = cell.taskDetail.text
                break
            default:
                break
            }
        }
        
        if let name = taskName, let detail = taskDetail, let tag = taskTag, let dueDate = taskDueDate {
            if tag != ""{
                NetworkManager.getInstance().addTask(taskName: name, taskDetail: detail, taskTag: [tag], taskDueDate: dueDate, callback: self)
            }else {
                NetworkManager.getInstance().addTask(taskName: name, taskDetail: detail, taskTag: nil, taskDueDate: dueDate, callback: self)
            }
        }else if let taskNameText = taskName, let taskTagText = taskTag, let taskDetailText = taskDetail {
            if (taskNameText != "" && taskTagText != "" && taskDetailText != ""){
                NetworkManager.getInstance().addTask(taskName: taskNameText, taskDetail: taskDetailText, taskTag: [taskTagText], taskDueDate: nil, callback: self)
                EZLoadingActivity.show("Adding task", disableUI: true)
            }else if (taskNameText != "" && taskDetailText != ""){
                NetworkManager.getInstance().addTask(taskName: taskNameText, taskDetail: taskDetailText, taskTag: nil, taskDueDate: nil, callback: self)
                EZLoadingActivity.show("Adding task", disableUI: true)
            }else {
                var showText: String?
                if taskNameText == "" && taskDetailText == ""{
                    showText = "Please fill task name and task detail"
                }else if (taskNameText == ""){
                    showText = "Please fill task name"
                }else if (taskDetailText == ""){
                    showText = "Please fill task detail"
                }
                if let text = showText{
                    let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
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
    
    @IBAction func tagAddBtnToggle(_ sender: Any) {
        let picker = TCPickerView()
        picker.title = "Tag"
        let list = ["Hybrid", "Hybrid Edit", "Web Feature", "Web Edit", "App", "App Feature", "App Edit", "Design", "Test", "Other"]
        let values = list.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            var tags = [String]()
            for i in selectedIndexes {
                tags.append(values[i].title)
            }
            let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! CreateTaskTagFieldTableViewCell
            cell.taskTag.text = tags[0]
        }
        picker.show()
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
