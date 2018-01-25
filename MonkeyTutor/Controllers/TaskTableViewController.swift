//
//  TaskTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import expanding_collection

class TaskTableViewController: ExpandingTableViewController {
    
    var selectedStatus: TaskStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popTransitionAnimation()
    }
}
