//
//  iCloud.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 11.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import CloudKit

class DatabaseiCloud {
    func saveToiCloud(_ group: Group) {
        DispatchQueue.global(qos: .userInitiated).async {
            let groupRecord = CKRecord(recordType: "addedGroups")
            
            groupRecord.setValue(group.id, forKey: "id")
            groupRecord.setValue(group.name, forKey: "name")
            
            let container = CKContainer.default()
            let dataBase = container.publicCloudDatabase
            
            dataBase.save(groupRecord) { (record, error) in
                guard error == nil else { return }
                print("запись сохранена в iCloud")
            }
        }
    }
}


