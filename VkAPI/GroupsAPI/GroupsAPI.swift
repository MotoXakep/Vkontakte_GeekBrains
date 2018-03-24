//
//  GroupApi.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 24.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire

class GroupList: VkAPI {
    override var path: String { return "/method/groups.get"}
    var parameters: Parameters {
        return [
            "extended": 1,
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
}

class SearchGroup: VkAPI {
    override var path: String { return "/method/groups.search"}
    var searchString: String
    var parameters: Parameters {
        return [
            "q": searchString,
            "count": "150",
            "type": "group",
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    init (searchString: String) {
        self.searchString = searchString
    }
}

class GroupInfo: VkAPI {
    override var path: String { return "/method/groups.getById"}
    var groupId: String
    var parameters: Parameters {
        return [
            "group_ids": groupId,
            "fields": "members_count",
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    init (groupId: String) {
        self.groupId = groupId
    }
}

class JoinGroup: VkAPI {
    override var path: String { return "/method/groups.join"}
    var groupId: String
    var parameters: Parameters {
        return [
            "group_id": groupId,
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    init (groupId: String) {
        self.groupId = groupId
    }
}

class LeaveGroup: VkAPI {
    override var path: String { return "/method/groups.leave"}
    var groupId: String
    var parameters: Parameters {
        return [
            "group_id": groupId,
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    init (groupId: String) {
        self.groupId = groupId
    }
}
