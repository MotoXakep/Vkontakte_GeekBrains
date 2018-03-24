//
//  NewsRouter.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 11.01.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class NewsRouter  {
    
    let parser = News()
    let userId = FirebaseDatabase.instanse.userId
    
    
    func downloadNews(completion: @escaping ([New]) -> Void) {
        let downloadNewsParameters = DownloadNewsParameters()
        Alamofire.request(downloadNewsParameters.fullUrl,
                          method: .get,
                          parameters: downloadNewsParameters.parameters).responseData(queue: .global(qos: .userInteractive)) { response in
                            
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let news = self.parser.parse(json) as? [New]
                DispatchQueue.main.async {
                    completion(news ?? [])
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func postNewText (message: String, completion: @escaping (Int) -> ()) {
        let postNewTextParameters = PostNewTextParameters(message: message)
        
        Alamofire.request(postNewTextParameters.fullUrl,
                          method: .get,
                          parameters: postNewTextParameters.parameters).responseData(queue: .global(qos: .userInteractive)) { response in
                            
            guard let data = response.value else { return }
            do {
                var code = 0
                let json = try JSON(data: data)
                let codeReq = json["response"]["post_id"].intValue
                
                if codeReq > 0 {
                    code = 200
                } else {
                    code = json["error"]["error_code"].intValue
                }
                DispatchQueue.main.async {
                    completion(code)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    
    func recieveUrl(completion: @escaping (String) -> ()) {
        let wallUploadServerParameters = WallUploadServerParameters()
        
        Alamofire.request(wallUploadServerParameters.fullUrl,
                          method: .get,
                          parameters: wallUploadServerParameters.parameters).responseData(queue: .global(qos: .userInteractive)) { response in
                            
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let upload_url = json["response"]["upload_url"].stringValue
                
                DispatchQueue.main.async {
                    completion(upload_url)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func photoPostToWall (image: Data, completion: @escaping (Bool) -> ()) {
      
        recieveUrl() { [weak self] upload_url in
            let url = upload_url
        
        
        guard let urlRequest = try? URLRequest(url: url, method: HTTPMethod.post) else { return }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(image, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")},
                         with: urlRequest,
                         encodingCompletion: { [weak self] (encodingResult) in
                            
                            switch encodingResult {
                                
                            case .success(let upload, _, _):
                                
                                upload.responseData { [weak self] response in
                                    guard let data = response.value else { return }
                                    do {
                                        let json = try JSON(data: data)
                                        let imageHash = json["hash"].stringValue
                                        let imageServer = json["server"].stringValue
                                        let imagePhoto = json["photo"].stringValue
                                        guard imageHash != ""  else { return }
                                            
                                        self?.saveWallPhoto(imageHash: imageHash, imageServer: imageServer, imagePhoto: imagePhoto) { [weak self] photoId in
                                            
                                            self?.postWallPhoto(ownerId: (self?.userId ?? ""), photoId: photoId) { postId in
                                                if postId > 0 {
                                                    completion(true)
                                                } else {
                                                    completion(false)
                                                }
                                            }
                                        }
                                        
                                        
                                    } catch {
                                        assertionFailure(error.localizedDescription)
                                    }
                                }
                                return
                            case .failure( _):
                                completion(false)
                            }
        })
      }
    }
    
    func saveWallPhoto(imageHash: String, imageServer: String, imagePhoto: String, completion: @escaping (String) -> ()) {
        let saveWallPhotoParameters = SaveWallPhotoParameters(server: imageServer, hash: imageHash, photo: imagePhoto)
        
        Alamofire.request(saveWallPhotoParameters.fullUrl,
                          method: .get,
                          parameters: saveWallPhotoParameters.parameters).responseData(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                            
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let photoId = json["response"][0]["id"].stringValue
                DispatchQueue.main.async {
                    completion(photoId)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        
    }
    
    func postWallPhoto(ownerId: String, photoId: String, completion: @escaping (Int) -> ()){
        let wallphotoPostParameters = WallPhotoPostParameters(ownerId: ownerId, photoId: photoId)
        
        Alamofire.request(wallphotoPostParameters.fullUrl,
                          method: .get,
                          parameters: wallphotoPostParameters.parameters).responseData(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                            
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let postId = json["response"]["post_id"].intValue
                DispatchQueue.main.async {
                    completion(postId)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}


