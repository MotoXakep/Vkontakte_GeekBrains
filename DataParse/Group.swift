//
//  Group.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON

class GroupRequest: Codable {
    let response: GroupsListResponse
}

class GroupsListResponse: Codable {
    var items = [Group]()
    
}

class Group: Object, Codable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo_50 = ""
    var count: Int?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        name = json["name"].stringValue
        photo_50 = json["photo_50"].stringValue
        count = json["members_count"].intValue
        id = json["id"].intValue
    }
}
