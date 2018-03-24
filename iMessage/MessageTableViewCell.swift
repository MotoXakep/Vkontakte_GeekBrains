//
//  MessageTableViewCell.swift
//  iMessage
//
//  Created by Алексей Борисов on 21.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
    }

}
