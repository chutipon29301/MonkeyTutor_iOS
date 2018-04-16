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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "NewWorkflowView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
    }
    
    func setTag(tag: String) {
        self.tag.text = tag
    }
    
    func setDate(date: Date) {
        self.date.text = date.dateString
        currentDate = date
    }
    
    
}
