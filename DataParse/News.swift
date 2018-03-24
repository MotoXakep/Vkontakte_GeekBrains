//
//  News.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 11.01.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import SwiftyJSON

class New {
    
    var id = 0
    var sourceId = 0
    var likesCount = 0
    var repostsCount = 0
    var commentsCount = 0
    var viewsCount = 0
    var text: String?
    var photoLink: String?
    var user: User?
    var group: Group?
}

struct News {
    
    let newJson = { (json: JSON, groups: [Group], users: [User]) -> New in
        var new = New()
        let type = json["type"].stringValue
        new.sourceId = json["source_id"].intValue
        
        switch type {
            
        case "post":
            new.id = json["post_id"].intValue
            new.likesCount = json["likes"]["count"].intValue
            new.repostsCount = json["reposts"]["count"].intValue
            new.commentsCount = json["comments"]["count"].intValue
            new.viewsCount = json["views"]["count"].intValue
            new.text = json["text"].stringValue
            
            let arrayPhotoUrl = json["attachments"].flatMap {$0.1["photo"]["photo_604"].string}
            
            if arrayPhotoUrl.count > 0 {
                new.photoLink = arrayPhotoUrl[0]
            } else {
                let json = json["copy_history"][0]
                new.text = json["text"].stringValue
                new.photoLink = json["attachments"]["photo"]["photo_604"].stringValue
                new.likesCount = json["likes"]["count"].intValue
                new.repostsCount = json["reposts"]["count"].intValue
                new.commentsCount = json["comments"]["count"].intValue
            }
            
        default:
            let json = json["photos"]["items"][0]
            new.text = json["text"].stringValue
            new.photoLink = json["attachments"]["photo"]["photo_604"].stringValue
            new.likesCount = json["likes"]["count"].intValue
            new.repostsCount = json["reposts"]["count"].intValue
            new.commentsCount = json["comments"]["count"].intValue
        }
        
        if new.sourceId > 0 {
            new.user = users.filter { $0.id == new.sourceId }.first
        } else {
            new.group = groups.filter { $0.id == abs(new.sourceId) }.first
        }
        
        return new
    }
    
    func parse(_ json: JSON) -> [AnyObject] {
        let groups = json["response"]["groups"].map { Group(json: $0.1) }
        let users = json["response"]["profiles"].map { User(json: $0.1) }
        return json["response"]["items"].flatMap { newJson($0.1, groups, users) }
    }
}
