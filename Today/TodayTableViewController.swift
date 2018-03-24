//
//  TodayTableViewController.swift
//  Today
//
//  Created by Алексей Борисов on 20.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayTableViewController: UITableViewController, NCWidgetProviding  {
    
    lazy var photoService: PhotoService = PhotoService(container: tableView)
    var friendsNames = [""]
    var friendsPhotos = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriends()
    }
    
    func loadFriends() {
        let defaults = UserDefaults(suiteName: "group.vk")
        guard
            let friendsName = defaults?.stringArray(forKey: "friendsNames"),
            let friendsPhoto = defaults?.stringArray(forKey: "friendsPhotos") else { return }
        
        self.friendsNames = friendsName
        self.friendsPhotos = friendsPhoto
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayFriendsCell", for: indexPath) as! TodayTableViewCell
       
        cell.friendName.text = friendsNames[indexPath.row]
        cell.avatar.image = photoService.photo(atIndexpath: indexPath, byUrl: friendsPhotos[indexPath.row])

        return cell
    }
}
