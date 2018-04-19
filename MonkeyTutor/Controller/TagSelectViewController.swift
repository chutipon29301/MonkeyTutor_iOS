//
//  TagSelectViewController.swift
//  MonkeyTutor
//
//  Created by admin on 15/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

protocol TagSelectorDelegate {
    func setTag(tag: Workflow.Tags)
}

class TagSelectViewController: UIViewController {
    
    @IBAction func tagBtnTapped(_ sender: Any) {
        if let button = sender as? MDCFloatingButton, let parent = self.presentingViewController as? TagSelectorDelegate {
            parent.setTag(tag: Workflow.Tags.allValues[button.tag])
            dismiss(animated: true, completion: nil)
        }
    }
    
}
