//
//  NewWorkflowViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialDialogs

class NewWorkflowViewController: UIViewController {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tag: UILabel!
    
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
        let dialogTransistionController = MDCDialogTransitionController()
        let tagSelectViewController = TagSelectViewController()
        tagSelectViewController.modalPresentationStyle = .custom
        tagSelectViewController.transitioningDelegate = dialogTransistionController
        tagSelectViewController.preferredContentSize = CGSize(width: 300, height: 300)
        present(tagSelectViewController, animated: true, completion: nil)
    }
    
    @IBAction func dateSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            let dialogTransistionController = MDCDialogTransitionController()
            let dateSelectViewController = DateSelectViewController()
            dateSelectViewController.modalPresentationStyle = .custom
            dateSelectViewController.transitioningDelegate = dialogTransistionController
            dateSelectViewController.preferredContentSize = CGSize(width: 300, height: 300)
            present(dateSelectViewController, animated: true, completion: nil)
        } else {
            date.text = "none"
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
    }
    
    func setTag(tag: String) {
        self.tag.text = tag
    }
    
}
