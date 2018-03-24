//
//  NewsAPI.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 23.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire

class DownloadNewsParameters: VkAPI {
    override var path: String { return "/method/newsfeed.get" }
    var parameters: Parameters {
        return [
            "filters": "post,photo,wall_photo",
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
}

class PostNewTextParameters: VkAPI {
    var message: String
    var lat = ""
    var long = ""
    var codeReqest = 0
    override var path: String { return "/method/wall.post" }
    
    var parameters: Parameters {
        return [
            "friends_only": "1",
            "message": message,
            "lat": lat,
            "long": long,
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    
    init(message: String) {
        self.message = message
    }
}

class WallUploadServerParameters: VkAPI {
    override var path: String { return "/method/photos.getWallUploadServer"}
    var parameters: Parameters {
        return [ "access_token":token,
                "v": constant.apiVersion ]
    }
}

class SaveWallPhotoParameters: VkAPI {
    override var path: String { return "/method/photos.saveWallPhoto"}
    var server: String
    var hash: String
    var photo: String
    
    var parameters: Parameters {
        return [ "server": server,
                "photo": photo,
                "hash": hash,
                "access_token": token,
                "v": constant.apiVersion ]
    }
    init (server: String, hash: String, photo: String) {
        self.server = server
        self.hash = hash
        self.photo = photo
    }
}

class WallPhotoPostParameters: VkAPI {
    override var path: String { return "/method/wall.post"}
    var ownerId: String
    var photoId: String
    var parameters: Parameters {
        return [ "owner_id": ownerId,
                 "friends_only" : 1,
                "attachments": "photo" + ownerId + "_" + photoId,
                "access_token": token,
                "v": constant.apiVersion ]
    }
    init (ownerId: String, photoId: String) {
        self.ownerId = ownerId
        self.photoId = photoId
    }
}

