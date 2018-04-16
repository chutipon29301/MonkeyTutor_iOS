//
//  Extension.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs

extension UIViewController {
    
    func presentDialog(_ view: UIViewController, size: CGSize?, completion: (() -> Void)?) {
        let dialogTransistionController = MDCDialogTransitionController()
        view.modalPresentationStyle = .custom
        view.transitioningDelegate = dialogTransistionController
        if let size = size {
            view.preferredContentSize = size
        }
        present(view, animated: true, completion: completion)
    }
    
}

extension Date {
    
    var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: self)
        }
    }
    
}
