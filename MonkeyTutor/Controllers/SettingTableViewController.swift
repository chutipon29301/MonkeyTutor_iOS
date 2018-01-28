//
//  SettingViewController.swift
//  MonkeyTutor
//
//  Created by admin on 23/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import BulletinBoard

class SettingTableViewController: UITableViewController {
    
    lazy var bulletinManager: BulletinManager = {
        let page = PageBulletinItem(title: "Logout")
        page.descriptionText = "Are you sure you want to logout"
        page.actionButtonTitle = "Logout"
        page.alternativeButtonTitle = "Not now"
        page.actionHandler = { (item: PageBulletinItem) in
            RealmManager.getInstance().removeLoginUser()
            self.parent?.parent?.dismiss(animated: true, completion: nil)
        }
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.dismissBulletin()
        }
        page.isDismissable = true
        let rootItem: BulletinItem = page
        return BulletinManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                tableView.deselectRow(at: indexPath, animated: true)
                bulletinManager.prepare()
                bulletinManager.presentBulletin(above: self)
                break
            default:
                break
            }
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func dismissBulletin() {
        bulletinManager.dismissBulletin()
    }
}
