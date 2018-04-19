//
//  AssignWorkflowDetailViewController.swift
//  MonkeyTutor
//
//  Created by admin on 18/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

protocol AssignWorkflowDetailDelegate {
    func assignWorkflowDetail(subtitle: String?, detail: String?, date: Date?, tutor: Tutor)
}

class AssignWorkflowDetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: MDCTextField!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detail: UITextView!
    private var currentDate: Date?
    private var loadingViewController: LoadingViewController?
    private var tutor: Tutor?
    
    convenience init(tutor: Tutor) {
        self.init()
        self.tutor = tutor
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
        if let parent = presentingViewController as? AssignWorkflowDetailDelegate,
            let tutor = tutor
        {
            dismiss(animated: true, completion: {
                parent.assignWorkflowDetail(subtitle: self.subtitle.text, detail: self.detail.text, date: self.currentDate, tutor: tutor)
            })
        }
    }
}

extension AssignWorkflowDetailViewController: DateSelectorDelegate {
    
    func setDate(date: Date) {
        self.date.text = date.dateString
        currentDate = date
    }
    
}
