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

class CreateTaskTableViewController: UITableViewController, AddTaskResutlDelegate {
    
    @IBOutlet weak var taskName: TextField!
    @IBOutlet weak var tag: TextField!
    @IBOutlet weak var taskDetail: TextView!
    
    
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
        if let taskNameText = taskName.text, let taskTagText = tag.text, let taskDetailText = taskDetail.text {
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
                    let alert = UIAlertController(title: "Aleart", message: text, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func onAddTaskDone(isSuccess: Bool) {
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
}
