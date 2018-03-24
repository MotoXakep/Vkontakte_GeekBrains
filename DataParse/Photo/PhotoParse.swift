//
//  Photo.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PhotoRequest: Codable {
    let response: PhotoListResponse
}

class PhotoListResponse: Codable {
    var items = [Photo]()
}

class Photo: Object, Codable {
    @objc dynamic var photo_130: String = ""
}
