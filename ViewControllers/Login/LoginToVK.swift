//
//  LoginToVK.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 29.11.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class LoginToVK: UIViewController, WKNavigationDelegate {
    
    var constants = ConstantsVK()
    var vkLogin = VkLogin()
    
    @IBOutlet weak var webView: WKWebView! {
        didSet { webView.navigationDelegate = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    func login() {
        do {
            let request = try vkLogin.login()
            webView.load(request)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        let token = ""
        KeychainWrapper.standard.set(token, forKey: "token")
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName == "vk.com" {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                         for: [record],
                                         completionHandler: {self.login()})
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard  let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = vkLogin.parseUrlFragment(parameters: fragment)
        
        guard let token = params["access_token"] else {
            print("токен не найден")
            return
        }
        
        decisionHandler(.cancel)
        if KeychainWrapper.standard.set(token, forKey: "token") {
            performSegue(withIdentifier: "Login", sender: nil)
        }
    }
    
    @IBAction func loginUnwindAction(segue: UIStoryboardSegue) {
        logoutVK()
    }
}
