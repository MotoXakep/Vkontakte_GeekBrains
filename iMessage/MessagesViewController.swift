//
//  MessagesViewController.swift
//  iMessage
//
//  Created by Алексей Борисов on 20.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var photoService: PhotoService = PhotoService(container: tableView)
    
    var friends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadFriends()
    }
    
    func loadFriends() {
        let defaults = UserDefaults(suiteName: "group.vk")
        guard
            let friendsName = defaults?.stringArray(forKey: "friendsNames"),
            let friendsPhoto = defaults?.stringArray(forKey: "friendsPhotos"),
            let friendsId = defaults?.stringArray(forKey: "friendsId") else { return }
        
        for index in 0..<friendsId.count {
            var friend = Friend()
            friend.friendId = friendsId[index]
            friend.friendName = friendsName[index]
            friend.friendPhotoUrl = friendsPhoto[index]
            friends.append(friend)
        }
    }
    
    func send(friend: Friend, photo: UIImage?) {
        let stringUrl = "http://vk.com/id" + friend.friendId
        let layout = MSMessageTemplateLayout()
        layout.caption = stringUrl
        layout.imageTitle = friend.friendName
        layout.image = photo
        
        let message = MSMessage()
        message.url = URL(string: stringUrl)
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageFriendsCell", for: indexPath) as! MessageTableViewCell
        let friend = friends[indexPath.row]
        
        cell.friendName.text = friend.friendName
        cell.avatar.image = photoService.photo(atIndexpath: indexPath, byUrl: friend.friendPhotoUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let friend = friends[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
        let avatar = cell.avatar.image
        send(friend: friend, photo: avatar)
        return indexPath
    }
}

