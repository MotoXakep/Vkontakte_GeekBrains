//
//  UserGroupsController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UserGroupsController: UITableViewController {
    
    var groups: Results<Group>?
    var token: NotificationToken?
    var groupRouter = GroupRouter()
    
    lazy var photoService = PhotoService(container: tableView)
    func update () {
        pairTableAndRealm()
        groupRouter.downloadGroups()
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
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsCell", for: indexPath) as! UserGroupsCell
        guard let userGroup = groups?[indexPath.row] else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.groupName.text = userGroup.name
        cell.imageGroup.image = photoService.photo(atIndexpath: indexPath, byUrl: userGroup.photo_50)
        return cell
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        groups = realm.objects(Group.self)
        
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let group = groups?[indexPath.row] else { return }
            groupRouter.leaveGroupReq(groupId: group.id)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(group)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addGroupSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
        }
    }
    
    deinit {
        token?.invalidate()
    }
}
