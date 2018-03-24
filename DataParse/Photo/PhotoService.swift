//
//  PhotoService.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 14.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class PhotoService {
    
    private let syncQueue = DispatchQueue(label: "com.AELab.photoService", qos: .userInteractive)
    private let container: DataReloadable
    private let imageCache = AutoPurgingImageCache()
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }

    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        if let photo = imageCache.image(withIdentifier: url) {
            image = photo
        } else {
            loadPhoto(atIndexpath: indexPath, byUrl: url)
        }
        return image
    }
    
    private func loadPhoto(atIndexpath indexPath: IndexPath, byUrl url: String) {
        Alamofire.request(url).responseImage(queue: syncQueue) { [weak self] response in
            guard
                let data = response.data,
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.imageCache.add(image, withIdentifier: url)
                self?.container.reloadRow(atIndexpath: indexPath)
            }
        }
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexpath indexPath: IndexPath)
}

extension PhotoService {
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexpath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}
