//
//  UserRouter.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import Realm
import RealmSwift
import SwiftKeychainWrapper

class UserRouter  {
    var constant: ConstantsVK
    let token: String = KeychainWrapper.standard.string(forKey: "token") ?? ""
    
    let method: HTTPMethod = .get
    var path = "/method/friends.get"
    
    var parameters: Parameters {
        return [
            "access_token": token,
            "v": constant.apiVersion,
            "order": "hints",
            "fields":"nickname,domain,photo_50"
        ]
    }
    
    init() {
        self.constant = ConstantsVK()
    }
    
    var fullUrl: URL {
        return constant.baseUrl.appendingPathComponent(path)
    }
    
    func saveUserData(_ users: [User]) {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            let realm = try Realm()
            let realmObjects = realm.objects(User.self)
            realm.beginWrite()
            realm.delete(realmObjects)
            realm.add(users, update: true)
            try realm.commitWrite()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

extension UserRouter {
    
    func downloadFriends() {
        Alamofire.request(fullUrl, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { [weak self] response in
            guard let data = response.value else { return }
            do {
                let result = try JSONDecoder().decode(UserRequest.self, from: data)
                DispatchQueue.main.async {
                    self?.saveUserData(result.response.items)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func photoReq(completion: @escaping ([Photo])->Void) {
        Alamofire.request(fullUrl, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            do {
                let result = try JSONDecoder().decode(PhotoRequest.self, from: data)
                DispatchQueue.main.async {
                    completion(result.response.items)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}




