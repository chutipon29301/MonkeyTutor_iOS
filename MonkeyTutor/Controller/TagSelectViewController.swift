//
//  TagSelectViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class TagSelectViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "TagSelectView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tagBtnTapped(_ sender: Any) {
        if let button = sender as? MDCFloatingButton, let parent = self.presentingViewController as? NewWorkflowViewController {
            parent.setTag(tag: WorkflowManager.tags[button.tag])
            dismiss(animated: true, completion: nil)
        }
    }
}
