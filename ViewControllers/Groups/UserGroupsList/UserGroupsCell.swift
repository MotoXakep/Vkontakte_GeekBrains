//
//  UserGroupsCell.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit

class UserGroupsCell: UITableViewCell {
    
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageGroup.layer.cornerRadius = imageGroup.frame.size.width / 2
        imageGroup.clipsToBounds = true
    }
}
