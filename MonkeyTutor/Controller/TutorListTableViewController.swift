//
//  TutorListTableViewController.swift
//  MonkeyTutor
//
//  Created by admin on 29/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class TutorListTableViewController: UITableViewController, TutorUpdateResult {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TutorManager.shared.delegate = self
        TutorManager.shared.update()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TutorManager.shared.tutors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorCell") as! TutorListTableViewCell
        cell.name.text = TutorManager.shared.tutors[indexPath.row].nicknameEn
        cell.colorTag.backgroundColor = TutorColorManager.shared.getTutorColor(tutor: TutorManager.shared.tutors[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDialog(ColorPickerViewController(tutor: TutorManager.shared.tutors[indexPath.row], delegate: self), size: CGSize(width: 300, height: 400), completion: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
    
    func tutorDataUpdate(success: Bool) {
        if success {
            tableView.reloadData()
        }
    }
    
}

class TutorListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var colorTag: UIView!
    
}
