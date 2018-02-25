//
//  TaskViewController.swift
//  MonkeyTutor
//
//  Created by admin on 22/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import expanding_collection

class TaskViewController: ExpandingViewController, FetchResultDelegate {
    
    let cardLabelColor = [
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    ]
    
    let cardColor = [
        UIColor(red: 111/255.0, green: 204/255.0, blue: 218/255.0, alpha: 1.0),
        UIColor(red: 229/255.0, green: 172/255.0, blue: 206/255.0, alpha: 1.0),
        UIColor(red: 249/255.0, green: 168/255.0, blue: 111/255.0, alpha: 1.0),
        UIColor(red: 152/255.0, green: 207/255.0, blue: 142/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 163/255.0, blue: 163/255.0, alpha: 1.0)
    ]
    
    let cardIcon = [
        UIImage(named:"pin"),
        UIImage(named:"glasshour"),
        UIImage(named:"assign"),
        UIImage(named:"checked"),
        UIImage(named:"checked")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = RealmManager.getInstance().getExistingLoginUser()?.userID {
            NotificationTokenManager.getInstance().registerDeviceWith(userID: id)
        }
        itemSize = CGSize(width: 300, height: 400)
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "TaskCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CollectionViewTaskManager.getInstance().fetch(callback: self)
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController: TaskTableViewController = storyboard.instantiateViewController(withIdentifier: "TaskTableViewController") as! TaskTableViewController
        return toViewController
    }
    
}

extension TaskViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionViewTaskManager.getInstance().getTaskStatusCount().count
    }
    
    override func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        let row = indexPath.row
        let taskInfo = CollectionViewTaskManager.getInstance().getTaskStatusCount()[row]
        let tagCount = CollectionViewTaskManager.getInstance().getTaskTagCounWitht(status: CollectionViewTaskManager.getInstance().getTaskStatusCount()[row].2)

        cell.cardLabel.textColor = cardLabelColor[row]
        cell.taskCountLabel.textColor = cardLabelColor[row]
        cell.taskCountLabel.text = "\(taskInfo.1) tasks"
        cell.frontContainerView.backgroundColor = cardColor[row]
        cell.cardIcon.image = cardIcon[row]
        cell.cardLabel.text = taskInfo.0
        
        cell.hybridCountLabel.textColor = cardLabelColor[row]
        cell.hybridCountLabel.text = ": \(tagCount[0])"
        cell.appCountLabel.textColor = cardLabelColor[row]
        cell.appCountLabel.text = ": \(tagCount[1])"
        cell.webCountLabel.textColor = cardLabelColor[row]
        cell.webCountLabel.text = ": \(tagCount[2])"
        cell.testCountLabel.textColor = cardLabelColor[row]
        cell.testCountLabel.text = ": \(tagCount[3])"
        cell.designCountLabel.textColor = cardLabelColor[row]
        cell.designCountLabel.text = ": \(tagCount[4])"
        cell.otherCountLabel.textColor = cardLabelColor[row]
        cell.otherCountLabel.text = ": \(tagCount[5])"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let destination = getViewController() as? TaskTableViewController {
            destination.selectedStatus = CollectionViewTaskManager.getInstance().getTaskStatusCount()[indexPath.row].2
            pushToViewController(destination)
        }
    }
}

extension TaskViewController {
    func onFetchResultComplete() {
        collectionView?.reloadData()
    }
}

class TaskCollectionViewCell: BasePageCollectionCell {
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var hybridCountLabel: UILabel!
    @IBOutlet weak var webCountLabel: UILabel!
    @IBOutlet weak var appCountLabel: UILabel!
    @IBOutlet weak var designCountLabel: UILabel!
    @IBOutlet weak var testCountLabel: UILabel!
    @IBOutlet weak var otherCountLabel: UILabel!
}

