//
//  Firebase.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 23.02.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabase {
    
    static let instanse = FirebaseDatabase()
    private lazy var ref = Database.database().reference()
    
    var userId = ""
    
    private init() {}
    
    func saveUser() {
        ref.child("Users").child(userId).setValue(userId)
    }
    
    func userJoinToGroup(_ group: Group) {
        ref.child("Users").child(userId).child("addedGroups").child(String(group.id)).setValue(group.name)
    }
}
