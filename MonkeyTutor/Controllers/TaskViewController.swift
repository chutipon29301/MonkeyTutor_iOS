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
        UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),
        UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    ]
    
    let cardColor = [
        UIColor(red: 0/255.0, green: 170/255.0, blue: 160/255.0, alpha: 1.0),
        UIColor(red: 142/255.0, green: 210/255.0, blue: 201/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 184/255.0, blue: 95/255.0, alpha: 1.0),
        UIColor(red: 255/255.0, green: 122/255.0, blue: 90/255.0, alpha: 1.0)
    ]
    
    let cardIcon = [
        UIImage(named:"pin"),
        UIImage(named:"glasshour"),
        UIImage(named:"assign"),
        UIImage(named:"checked")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSize = CGSize(width: 214, height: 264)
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

        cell.cardLabel.textColor = cardLabelColor[row]
        cell.taskCountLabel.textColor = cardLabelColor[row]
        cell.taskCountLabel.text = "\(taskInfo.1) tasks"
        cell.frontContainerView.backgroundColor = cardColor[row]
        cell.cardIcon.image = cardIcon[row]
        cell.cardLabel.text = taskInfo.0
        
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
}

