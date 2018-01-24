//
//  TaskViewController.swift
//  MonkeyTutor
//
//  Created by admin on 22/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import expanding_collection

class TaskViewController: ExpandingViewController {
    
    let cardLabel = ["TODO", "In Progress", "Assign", "Done"]
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
        itemSize = CGSize(width: 214, height: 264)
        super.viewDidLoad()
        
        // register cell
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "TaskCollectionViewCell")
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController: TaskTableViewController = storyboard.instantiateViewController(withIdentifier: "TaskTableViewController") as! TaskTableViewController
        return toViewController
    }
}

extension TaskViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        cell.cardLabel.text = cardLabel[indexPath.row]
        cell.cardLabel.textColor = cardLabelColor[indexPath.row]
        cell.taskCountLabel.textColor = cardLabelColor[indexPath.row]
        cell.frontContainerView.backgroundColor = cardColor[indexPath.row]
        cell.cardIcon.image = cardIcon[indexPath.row]
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

class TaskCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var cardIcon: UIImageView!
    
    
}

