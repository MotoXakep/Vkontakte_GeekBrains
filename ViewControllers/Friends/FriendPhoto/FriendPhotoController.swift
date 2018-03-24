//
//  FriendPhotoController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit

class FriendPhotoController: UICollectionViewController {
    
    var userId = 0
    var photos = [Photo]()
    var userRouter = UserRouter()
    lazy var photoService = PhotoService(container: collectionView!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUPhoto()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendPhotoCell
        cell.photoFriend.image = photoService.photo(atIndexpath: indexPath, byUrl: photos[indexPath.row].photo_130)
        return cell
    }
    
    func showUPhoto() {
        UserPhoto(ownerId: userId).userPhotoReq(forUser: userId) { [weak self] photos in
            self?.photos = photos
            self?.collectionView?.reloadData()
        }
    }
}
