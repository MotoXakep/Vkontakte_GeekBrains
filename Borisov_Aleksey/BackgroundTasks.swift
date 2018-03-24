//
//  BackgroundTasks.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 06.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Background {
    
    let fetchGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var newFriends: NewFriends?
    
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "Last Update") as? Date
        } set {
            UserDefaults.standard.setValue(Date(), forKey: "Last Update") }
    }
    
    func loadBackground(_ application: UIApplication, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Вызов обновления данных в фоне \(Date())")
        
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            print("Данные обновлялись меньше 30 секунд назад")
            completionHandler(.noData)
            return
        }
        
        let newFriendsRouter = NewFriendsRouter()
        newFriendsRouter.newFriendsReq {[weak self] array in
            self?.newFriends = NewFriends(idFriends: array)
            self?.newFriends?.downloadNewFriends()
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = array.count
            }
        }
        
        fetchGroup.notify(queue: DispatchQueue.main) {
            print("Все данные загружены в фоне")
            self.timer = nil
            self.lastUpdate = Date()
            completionHandler(.newData)
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 29, leeway: .seconds(1))
        timer?.setEventHandler {
            print("Не смогли загрузить данные")
            completionHandler(.failed)
            return
        }
        timer?.resume()
    }
    
    func realmFriendsToUserDefaults() {
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            let defaults = UserDefaults(suiteName: "group.vk")
            var friendsObjects = [Friend]()
            
            for user in users {
                var friend = Friend()
                friend.friendName = user.fullName
                friend.friendPhotoUrl = user.photo_50
                friend.friendId = String(user.id)
                friendsObjects.append(friend)
            }
            
            defaults?.set(friendsObjects.map {$0.friendName}, forKey: "friendsNames")
            defaults?.set(friendsObjects.map {$0.friendPhotoUrl}, forKey: "friendsPhotos")
            defaults?.set(friendsObjects.map {$0.friendId}, forKey: "friendsId")
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func friendsToSession() -> [String : Any]? {
        let defaults = UserDefaults(suiteName: "group.vk")
        var friends = [String : Any]()
        
        guard
            let friendsName = defaults?.stringArray(forKey: "friendsNames"),
            let friendsPhoto = defaults?.stringArray(forKey: "friendsPhotos") else { return nil }
        
        for index in 0..<friendsName.count {
            var friend = Friend()
            friend.friendName = friendsName[index]
            friend.friendPhotoUrl = friendsPhoto[index]
            friends[String(index)] = ["name" : friend.friendName, "imageUrl" : friend.friendPhotoUrl ]
        }
        friends["count"] = friendsName.count
        return friends
    }
}

