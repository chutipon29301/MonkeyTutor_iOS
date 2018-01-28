//
//  TutorDataManager.swift
//  MonkeyTutor
//
//  Created by admin on 27/1/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import SwiftyJSON

class TutorDataManager: ListTutorResultDelegate {
    
    private var tutorList = [Tutor]()

    private static var sharedTutorDataManager: TutorDataManager = {
        let tutorDataManager = TutorDataManager()
        return tutorDataManager
    }()
    
    class func getInstance() -> TutorDataManager {
        return sharedTutorDataManager
    }
    
    func fetch() {
        NetworkManager.getInstance().listTutor(callback: self)
    }
    
    func onListTutorDone(data: Any?) {
        tutorList = [Tutor]()
        if let existData = data {
            let jsonData = JSON(existData)
            let tutors = JSON(jsonData["tutors"])
            for ( _, subJson):(String, JSON) in tutors {
                let tutor = Tutor()
                tutor.id = subJson["tutorID"].intValue
                tutor.nicknameEn = subJson["nicknameEn"].stringValue
                if !tutorList.contains{ $0.id == tutor.id } {
                    tutorList.append(tutor)
                }
            }
        }
    }
    
    func getTutorList() -> [Tutor] {
        return tutorList
    }
}
