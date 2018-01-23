//
//  ViewController.swift
//  MonkeyTutor
//
//  Created by admin on 14/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import TransitionButton
import MaterialTextField
import EZLoadingActivity

class ViewController: UIViewController, LoginResultDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var username: MFTextField!
    @IBOutlet weak var password: MFTextField!
    @IBOutlet weak var loginButton: TransitionButton!
    var isAutoLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        password.delegate = self
        if let userInfo = RealmManager.getInstance().getExistingLoginUser() {
            loginButton.startAnimation()
            NetworkManager.getInstance().login(userID: userInfo.userID, password: userInfo.password, callback: self)
            EZLoadingActivity.show("Logging in...", disableUI: true)
            isAutoLogin = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        loginButton.startAnimation()
        if let id = username.text, let pass = password.text {
            NetworkManager.getInstance().login(userID: id, password: pass, callback: self)
        }else{
            loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: nil)
        }
    }
    
    func loginResult(isSuccess: Bool) {
        if isSuccess {
            if self.isAutoLogin {
                EZLoadingActivity.hide(true, animated: true)
                self.isAutoLogin = false
            } else {
                if let id = self.username.text, let pass = self.password.text {
                    RealmManager.getInstance().addUser(userID: id, password: pass)
                }
            }
            loginButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 2, completion: {
                self.performSegue(withIdentifier: "loginRedirect", sender: nil)
            })
        }else {
            if self.isAutoLogin {
                EZLoadingActivity.hide(false, animated: true)
                self.isAutoLogin = false
            }
            loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}

