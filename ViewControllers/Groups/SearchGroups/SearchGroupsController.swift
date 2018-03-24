//
//  SearchGroupsController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit

class SearchGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var groups = [Group]()
    var groupRouter = GroupRouter()
    var firebase = FirebaseDatabase.instanse
    let databaseiCloud = DatabaseiCloud()
    
    lazy var photoService = PhotoService(container: tableView)
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupCell", for: indexPath) as! SearchGroupsCell
        let group = groups[indexPath.row]
        let groupMembers = group.count ?? 0
        
        cell.allGroupName.text = group.name
        cell.numberMembers.text = String(describing: groupMembers)
        cell.imageAllGroup.image = photoService.photo(atIndexpath: indexPath, byUrl: group.photo_50)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = groups[indexPath.row].id
        let addedGroup = groups[indexPath.row]
        groupRouter.joinGroupReq(groupId: id) { [weak self] in
            self?.firebase.userJoinToGroup(addedGroup)
            self?.databaseiCloud.saveToiCloud(addedGroup)
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
        }
    }
}

extension SearchGroupsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
            !text.isEmpty else {
                tableView.reloadData()
                return
        }
        searchGroups(request: text)
        tableView.reloadData()
    }
    
    func searchGroups(request: String) {
        groupRouter.searchGroups(request: request) { [weak self] groups in
            self?.groups = groups
            self?.tableView.reloadData()
        }
    }
}

