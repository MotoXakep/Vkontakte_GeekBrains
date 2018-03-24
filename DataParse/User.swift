//
//  User.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON

class UserRequest: Codable {
    let response: FriendsListResponse
}

class FriendsListResponse: Codable {
   var items = [User]()
}

class User: Object, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var photo_50 = ""
    
    var fullName: String {
        return first_name + " " + last_name
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        first_name = json["first_name"].stringValue
        last_name = json["last_name"].stringValue
        photo_50 = json["photo_50"].stringValue
    }
}
