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
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 214, height: 264)
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "TaskCollectionViewCell")
        
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
        cell.cardLabel.text = CollectionViewTaskManager.getInstance().getTaskStatusCount()[indexPath.row].0
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TaskCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
        let destination = getViewController() as! TaskTableViewController
        destination.text = "Hello"
//        if cell.isOpened == false {
//            cell.cellIsOpen(true)
//        } else {
//            pushToViewController(getViewController())
//
//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
//        }
        
        pushToViewController(getViewController())
    }
}

extension TaskViewController {
    func onFetchResultComplete() {
        collectionView?.reloadData()
    }
}

class TaskCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet weak var cardLabel: UILabel!
    
}

