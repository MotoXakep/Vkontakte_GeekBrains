//
//  UserFriendsCell.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit

class UserFriendsCell: UITableViewCell {
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendAvatar.clipsToBounds = true
    }
}
