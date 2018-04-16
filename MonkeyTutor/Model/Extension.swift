//
//  Extension.swift
//  MonkeyTutor
//
//  Created by admin on 16/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialDialogs
import SwiftyJSON

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

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

extension Array where Element: Workflow {
    func filterWith(tags: Workflow.Tags) -> [Workflow] {
        return self.filter { $0.tag == tags }
    }
    
    func filterWith(status: Workflow.Status) -> [Workflow] {
        return self.filter { $0.status == status }
    }
    
    func countTags(_ tags: Workflow.Tags) -> Int {
        return filterWith(tags: tags).count
    }
}

public protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    private static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}

extension Array where Element == Workflow.Status {
    func findFrom(string: String?) -> Workflow.Status {
        if let value = string {
            let values = Workflow.Status.allValues
            let index = values.index(where: { $0.rawValue == value })
            return values[index ?? values.count - 1]
        } else {
            return .none
        }
        
    }
}

extension Array where Element == Workflow.Tags {
    func findFrom(string: String?) -> Workflow.Tags {
        if let value = string {
            let values = Workflow.Tags.allValues
            let index = values.index(where: { $0.rawValue == value })
            return values[index ?? values.count - 1]
        } else {
            return .other
        }
        
    }
}

extension JSON {
    func date() -> Date? {
        if let string = self.string {
            return Formatter.iso8601.date(from: string)
        } else {
            return nil
        }
    }
}
