//
//  PhotoRouter.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire

class UserPhoto: VkAPI {
    var ownerId: Int
    
    init(ownerId: Int) {
        self.ownerId = ownerId
    }
    
    override var path: String { return "/method/photos.getAll"}
    
    var parameters: Parameters {
        return [
            "owner_id": ownerId,
            "count": "150",
            "access_token": token,
            "v": constant.apiVersion
        ]
    }
    
    func userPhotoReq(forUser: Int, completion: @escaping ([Photo]) -> ()) {
        Alamofire.request(fullUrl, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            guard let data = response.value else { return }
            do {
                let result = try JSONDecoder().decode(PhotoRequest.self, from: data)
                DispatchQueue.main.async {
                    completion(result.response.items)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

