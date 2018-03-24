//
//  NewsTableViewController.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 11.01.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    lazy var photoService: PhotoService = PhotoService(container: tableView)
    var newsRouter = NewsRouter()
    var news = [New]()
    
    func update() {
        newsRouter.downloadNews() { [weak self] news in
            self?.news = news
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func update(_ sender: Any) {
        update()
    }
    
    @IBAction func unwindToNews(segue: UIStoryboardSegue) {
        guard segue.identifier == "backToNews" else { return }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        refreshControl?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refreshControl?.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let oneOfNews = news[indexPath.row]
        
        var autorName = ""
        var autorAvatarUrl = ""
        
        if let group = oneOfNews.group {
            autorName = group.name
            autorAvatarUrl = group.photo_50
        } else if let user = oneOfNews.user {
            autorName = user.fullName
            autorAvatarUrl = user.photo_50
        }
        
        if let mainPhotoUrl = oneOfNews.photoLink {
            cell.mainImage.image = photoService.photo(atIndexpath: indexPath, byUrl: mainPhotoUrl)
        } else {
            cell.mainImage.image = nil
        }
        
        cell.autorAvatar.image = photoService.photo(atIndexpath: indexPath, byUrl: autorAvatarUrl)
        cell.autorName.text = autorName
        cell.mainText.text = oneOfNews.text
        cell.likeCount.text = String(describing: oneOfNews.likesCount)
        cell.commentCount.text = String(describing: oneOfNews.commentsCount)
        cell.repostCount.text = String(describing: oneOfNews.repostsCount)
        cell.viewsCount.text = String(describing: oneOfNews.viewsCount)
        
        return cell
    }
}

