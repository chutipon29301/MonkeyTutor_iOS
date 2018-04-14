//
//  ObjectMapper.swift
//  MonkeyTutor
//
//  Created by admin on 13/4/2561 BE.
//  Copyright © 2561 MonkeyIT. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObjectMapper {
    
    static func mapLoginResult(_ jsonData: JSON) -> Bool {
        return jsonData["msg"].string == "ok" 
    }
    
}
