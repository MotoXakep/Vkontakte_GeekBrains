//
//  ConstantsVK.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 10.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class VkAPI {
    var constant = ConstantsVK()
    let token: String = KeychainWrapper.standard.string(forKey: "token") ?? ""
    var path: String { return "" }
    var fullUrl: URL {
        return constant.baseUrl.appendingPathComponent(path)
    }
}

struct ConstantsVK {
    let authUrl = URL(string: "https://oauth.vk.com/authorize")!
    let baseUrl = URL(string: "https://api.vk.com")!
    let redirectUrl = URL(string: "https://oauth.vk.com/blank.html")!
    var clientId = "6288169"
    var apiVersion = "5.73"
}

extension ConstantsVK {
    var parameters: Parameters { return
        [
        "client_id": clientId,
        "display": "mobile",
        "redirect_uri": redirectUrl,
        "scope": "270342",
        "response_type": "token",
        "v": apiVersion
        ]
    }
}
