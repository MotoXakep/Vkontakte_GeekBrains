//
//  NewFriendsRouter.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 06.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import Realm
import RealmSwift
import SwiftKeychainWrapper
import SwiftyJSON

class NewFriends {
    var constant: ConstantsVK
    let token: String = KeychainWrapper.standard.string(forKey: "token") ?? ""
    
    let method: HTTPMethod = .get
    var path = "/method/users.get"
    
    var idFriends: String
    
    var parameters: Parameters {
        return [
            "user_ids": idFriends,
            "fields": "photo_50",
            "name_case": "nom",
            "access_token": token,
            "v": constant.apiVersion,
        ]
    }
    
    init(idFriends: [Int]) {
        self.constant = ConstantsVK()
        self.idFriends = idFriends.map{"\($0)"}.reduce(","){$0+$1}
    }
    
    var fullUrl: URL {
        return constant.baseUrl.appendingPathComponent(path)
    }
    
    func saveNewFriends(_ users: [User]) {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users, update: true)
            try realm.commitWrite()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func downloadNewFriends() {
        Alamofire.request(fullUrl, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { [weak self] response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let users = json["response"].map { User(json: $0.1) }
                DispatchQueue.main.async {
                    self?.saveNewFriends(users)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

class NewFriendsRouter {
    var constant: ConstantsVK
    let token: String = KeychainWrapper.standard.string(forKey: "token") ?? ""
    
    let method: HTTPMethod = .get
    
    var reqPath: String { return "/method/friends.getRequests" }
    
    var reqParameters: Parameters {
        return [
            "out": 0,
            "access_token": token,
            "v": constant.apiVersion,
        ]
    }
    
    var reqFullUrl: URL {
        return constant.baseUrl.appendingPathComponent(reqPath)
    }
    
    init() {
        self.constant = ConstantsVK()
    }
    
    func newFriendsReq(completion: @escaping ([Int])->Void) {
        Alamofire.request(reqFullUrl, method: .get, parameters: reqParameters).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let newFriendsArray = json["response"]["items"].flatMap {$0.1.intValue}
                DispatchQueue.main.async {
                    completion(newFriendsArray)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

