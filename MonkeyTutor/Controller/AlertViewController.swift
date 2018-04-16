//
//  AlertViewController.swift
//  MonkeyTutor
//
//  Created by admin on 14/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var text: UITextView!
    var customText: String?
    
    convenience init(labelWith: String) {
        self.init()
        customText = labelWith
    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let labelText = customText {
            text.text = labelText
        }
    }
    
}
