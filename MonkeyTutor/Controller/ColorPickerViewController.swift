//
//  ColorPickerViewController.swift
//  MonkeyTutor
//
//  Created by admin on 29/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ColorPickerViewController: UIViewController, ChromaColorPickerDelegate {
    
    var selectTutor: Tutor?
    var neatColorPicker: ChromaColorPicker?
    var delegate: TutorUpdateResult?
    
    convenience init(tutor: Tutor, delegate: TutorUpdateResult) {
        self.init()
        selectTutor = tutor
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        if let neatColorPicker = neatColorPicker {
            neatColorPicker.delegate = self //ChromaColorPickerDelegate
            neatColorPicker.padding = 5
            neatColorPicker.stroke = 3
            neatColorPicker.hexLabel.textColor = UIColor.white
            neatColorPicker.center = CGPoint(x: 150, y: 250)
            view.addSubview(neatColorPicker)
        }
    }
    
    @IBAction func selectBtnTapped(_ sender: Any) {
        if let tutor = selectTutor,
            let color = neatColorPicker {
            TutorColorManager.shared.setTutorColor(tutor: tutor, color: color.currentColor)
            updateParent()
        }
    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        if let tutor = selectTutor {
            TutorColorManager.shared.setTutorColor(tutor: tutor, color: color)
            updateParent()
        }
    }
    
    func updateParent() {
        if let callback = delegate {
            callback.tutorDataUpdate(success: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
