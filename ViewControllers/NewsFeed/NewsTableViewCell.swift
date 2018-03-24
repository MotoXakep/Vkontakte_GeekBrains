//
//  NewsTableViewCell.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 11.01.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var autorAvatar: UIImageView!
    @IBOutlet weak var autorName: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        autorAvatar.layer.cornerRadius = autorAvatar.frame.size.width / 2
        autorAvatar.clipsToBounds = true
        mainText.layer.cornerRadius = mainText.frame.size.width / 50
        mainText.clipsToBounds = true
    }
}
