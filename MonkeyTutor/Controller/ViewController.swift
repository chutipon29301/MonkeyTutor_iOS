//
//  ViewController.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialDialogs

class ViewController: UIViewController, UITextFieldDelegate, LoginResultDelegate {
    
    @IBOutlet weak var userID: MDCTextField!
    @IBOutlet weak var password: MDCTextField!
    
    var loadingViewController: LoadingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(outsideTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserLoginManager.shared.isCurrentUserLoggin() {
            if let user = UserLoginManager.shared.getCurrentUser() {
                login(userID: user.userID, password: user.password)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if let userID = Int(userID.text!), let password = password.text {
            login(userID: userID, password: password)
        } else {
            presentAlertViewController(text: "Please enter valid user id and password")
        }
    }
    
    func login(userID: Int, password: String) {
        let dialogTransistionController = MDCDialogTransitionController()
        loadingViewController = LoadingViewController()
        if let view = loadingViewController {
            view.modalPresentationStyle = .custom
            view.transitioningDelegate = dialogTransistionController
            view.preferredContentSize = CGSize(width: 300, height: 200)
            present(view, animated: true, completion: {
                UserLoginManager.shared.login(userID: userID, password: password, resultDelegate: self)
            })
        }
    }
    
    func loginResult(isVerify: Bool) {
        if isVerify {
            loadingViewController?.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "showMainController", sender: nil)
            })
        } else {
            loadingViewController?.dismiss(animated: true, completion: {
                self.presentAlertViewController(text: "Wrong user id or password")
            })
        }
    }
    
    func presentAlertViewController(text: String) {
        let dialogTransistionController = MDCDialogTransitionController()
        let alertViewController = AlertViewController(labelWith: text)
        alertViewController.modalPresentationStyle = .custom
        alertViewController.transitioningDelegate = dialogTransistionController
        alertViewController.preferredContentSize = CGSize(width: 300, height: 250)
        present(alertViewController, animated: true, completion: nil)
    }
    
}
