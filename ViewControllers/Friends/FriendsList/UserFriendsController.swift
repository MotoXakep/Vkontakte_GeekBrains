//
//  UserFriendsController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Realm

class UserFriendsController: UITableViewController {
    
    var friends: Results<User>?
    var token: NotificationToken?
    var userRouter = UserRouter()
    
    lazy var firebase = FirebaseDatabase.instanse
    lazy var photoService: PhotoService = PhotoService(container: tableView)
    
    func update() {
        pairTableAndRealm()
        userRouter.downloadFriends()
        firebase.saveUser()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshControl?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refreshControl?.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        update()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendsCell", for: indexPath) as! UserFriendsCell
        guard  let friend = friends?[indexPath.row] else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.friendName.text = friend.fullName
        cell.friendAvatar.image = photoService.photo(atIndexpath: indexPath, byUrl: friend.photo_50)
        return cell
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendPhoto",
            let ctrl = segue.destination as? FriendPhotoController,
            let indexPath = tableView.indexPathForSelectedRow {
            let id = friends?[indexPath.row].id ?? 0
            ctrl.userId = id
        }
    }
    
    func loadFriends() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            tableView.reloadData()
        }
    }
    
    deinit {
        token?.invalidate()
    }
}


