//
//  GroupRouter.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import Realm
import RealmSwift
import SwiftyJSON

class GroupRouter  {
    let groupList = GroupList()
    
    func saveGroupData(_ groups: [Group]) {
        do {
            let realm = try Realm()
            let realmObjects = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(realmObjects)
            realm.add(groups, update: true)
            try realm.commitWrite()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func downloadGroups() {
        Alamofire.request(groupList.fullUrl, method: .get, parameters: groupList.parameters).responseData(queue: .global(qos: .userInteractive)) { [weak self] response in
            guard let data = response.value else { return }
            do {
                let result = try JSONDecoder().decode(GroupRequest.self, from: data)
                DispatchQueue.main.async {
                    self?.saveGroupData(result.response.items)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

extension GroupRouter  {
    
    func searchGroups(request: String, completion: @escaping ([Group]) -> () ) {
        let searchGroup = SearchGroup(searchString: request)
        Alamofire.request(searchGroup.fullUrl, method: .get, parameters: searchGroup.parameters).responseData(queue: .global(qos: .userInitiated)) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let groupsId = json["response"]["items"].array?.flatMap { String(describing: $0["id"].intValue) }.joined(separator: ",") ?? ""
                self.groupInfo(bygGoupsId: groupsId, completion: completion)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func groupInfo(bygGoupsId groupsId: String, completion: @escaping ([Group]) -> () ) {
        let groupInfo = GroupInfo(groupId: groupsId)
        Alamofire.request(groupInfo.fullUrl, method: .get, parameters: groupInfo.parameters).responseData(queue: .global(qos: .userInitiated)) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let groups = json["response"].array?.flatMap { Group(json: $0) } ?? []
                DispatchQueue.main.async {
                    completion(groups)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

extension GroupRouter {
    
    func leaveGroupReq(groupId: Int) {
        let id = String(describing: groupId)
        let leaveGroup = LeaveGroup(groupId: id)
        leaveGroup.groupId = id
        Alamofire.request(leaveGroup.fullUrl, method: .get, parameters: leaveGroup.parameters).responseData { response in
            self.downloadGroups()
        }
    }
}

extension GroupRouter {
    
    func joinGroupReq(groupId: Int, completion: @escaping () -> () ) {
        let id = String(describing: groupId)
        let joinGroup = JoinGroup(groupId: id)
        joinGroup.groupId = id
        Alamofire.request(joinGroup.fullUrl, method: .get, parameters: joinGroup.parameters).responseData { response in
            self.downloadGroups()
            completion()
        }
    }
}



