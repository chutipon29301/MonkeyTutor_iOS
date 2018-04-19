//
//  TutorManager.swift
//  MonkeyTutor
//
//  Created by admin on 18/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import RxSwift

protocol TutorUpdateResult {
    func tutorDataUpdate(success: Bool)
}

class TutorManager {
    
    static let shared = TutorManager()
    
    var delegate: TutorUpdateResult?
    private var _tutors: [Tutor] = []
    private var subscription: Disposable?
    
    private init() {
        update()
    }
    
    var tutors: [Tutor] {
        get {
            return _tutors
        }
    }
    
    func update() {
        subscription = NetworkManager.shared.listTutor().subscribe{
            switch $0 {
            case .next(let value):
                self._tutors = value.tutors
                self.delegate?.tutorDataUpdate(success: true)
                break
            case .error(_):
                self.delegate?.tutorDataUpdate(success: false)
                break
            case .completed:
                break
            }
        }
    }
    
    func cancel() {
        subscription?.dispose()
    }
    
}

class Tutor {
    
    private var _id: Int!
    private var _nicknameEn: String!
    
    init(id: Int, nicknameEn: String) {
        _id = id
        _nicknameEn = nicknameEn
    }
    
    var id: Int {
        get {
            return _id
        }
    }
    
    var nicknameEn: String {
        get {
            return _nicknameEn
        }
    }
    
}
