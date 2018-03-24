//
//  VkLogin.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 07.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire

struct VkLogin {
    
    let constants = ConstantsVK()
    var firebase = FirebaseDatabase.instanse
    
    func login() throws -> URLRequest {
        var urlRequest = URLRequest(url: constants.authUrl)
        urlRequest.httpMethod = "GET"
        return try URLEncoding.default.encode(urlRequest, with: constants.parameters)
    }
    
    func parseUrlFragment(parameters: String) -> [String: String] {
        let params = parameters
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        if let id = params["user_id"] {
            firebase.userId = id
        }
    
        return params
    }
}





