//
//  SearchGroupsCell.swift
//  Borisov_Aleksey
//
//  Created by Алексей Борисов on 03.12.2017.
//  Copyright © 2017 Aleksey Borisov. All rights reserved.
//

import UIKit

class SearchGroupsCell: UITableViewCell {
    
    @IBOutlet weak var imageAllGroup: UIImageView!
    @IBOutlet weak var numberMembers: UILabel!
    @IBOutlet weak var allGroupName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageAllGroup.layer.cornerRadius = imageAllGroup.frame.size.width / 2
        imageAllGroup.clipsToBounds = true
    }
}
