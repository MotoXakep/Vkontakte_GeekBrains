//
//  FriendsTableController.swift
//  WatchApp Extension
//
//  Created by Алексей Борисов on 21.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity
import Alamofire
import AlamofireImage

class FriendsTableController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession?
    var friendsData = [String : Any]()
    var friends = [Friend]()
    
    @IBOutlet var table: WKInterfaceTable!
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func updateTable() {
        table.setNumberOfRows(friends.count, withRowType: "friendRow")
        for index in 0..<friends.count {
            let friend = friends[index]
            let row = table.rowController(at: index) as! TableRow
       
            row.name.setText(friend.friendName)
        }
    }
    
    func loadFriends() {
        guard let count = friendsData["count"] as? Int  else { return }
        
        for index in 0..<count {
            var friend = Friend()
            
            if  let friendInfo = friendsData[String(index)] as? [String: Any],
                let name = friendInfo["name"] as? String,
                let imageUrl = friendInfo["imageUrl"] as? String
            {
                friend.friendName = name
                friend.friendPhotoUrl = imageUrl
                loadimage(url: friend.friendPhotoUrl, index: index) {[weak self] image in
                    let row = self?.table.rowController(at: index) as! TableRow
                    row.avatar.setImage(image)
                }
            }
            friends.insert(friend, at: index)
        }
        
        updateTable()
    }
    
    func loadimage(url: String, index: Int, completion: @escaping (UIImage) -> ()) {
        Alamofire.request(url).responseImage(queue: .global(qos: .userInteractive)) { response in
            guard
                let data = response.data,
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
               completion(image)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            session.sendMessage(["request": "friends"],
                                replyHandler: {[weak self] reply in
                                    self?.friendsData = reply
                                    self?.loadFriends()
                },
                                errorHandler: { error in
                                    print(error.localizedDescription)
            })
        }
    }
    
}
