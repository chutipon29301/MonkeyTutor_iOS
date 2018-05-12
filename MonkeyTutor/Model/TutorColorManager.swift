//
//  TutorColorManager.swift
//  MonkeyTutor
//
//  Created by admin on 12/5/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit

class TutorColorManager {
    
    static let shared = TutorColorManager()
    
    private init() { }
    
    func setTutorColor(tutor: Tutor, color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        RealmManager.shared.addTutorColor(nicknameEn: tutor.nicknameEn, red: Double(r), green: Double(g), blue: Double(b))
    }
    
    func getTutorColor(tutor: Tutor) -> UIColor {
        return getTutorColor(from: tutor.nicknameEn)
//        if let color = RealmManager.shared.getTutorColor(of: tutor.nicknameEn) {
//            return UIColor(red: CGFloat(color.colorR), green: CGFloat(color.colorG), blue: CGFloat(color.colorB), alpha: 1)
//        } else {
//            return UIColor.white
//        }
    }
    
    func getTutorColor(from name: String) -> UIColor {
        if let color = RealmManager.shared.getTutorColor(of: name) {
            return UIColor(red: CGFloat(color.colorR), green: CGFloat(color.colorG), blue: CGFloat(color.colorB), alpha: 1)
        } else {
            return UIColor.white
        }
    }
}
