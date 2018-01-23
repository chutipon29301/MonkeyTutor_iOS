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

class ViewController: UIViewController, LoginResultDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var username: MFTextField!
    @IBOutlet weak var password: MFTextField!
    @IBOutlet weak var loginButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        password.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            loginButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 2, completion: {
                self.performSegue(withIdentifier: "loginRedirect", sender: nil)
            })
        }else {
            loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}

