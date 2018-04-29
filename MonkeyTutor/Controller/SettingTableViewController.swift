//
//  SettingTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 14/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            performSegue(withIdentifier: "setUserColor", sender: nil)
            break
        case (1, 0):
            UserLoginManager.shared.logout()
            dismiss(animated: true, completion: nil)
            break
        default:
            super.tableView(tableView, didSelectRowAt: indexPath)
            break
        }
    }
    
}
