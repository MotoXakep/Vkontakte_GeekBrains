//
//  TodayTableViewCell.swift
//  Today
//
//  Created by Алексей Борисов on 20.03.2018.
//  Copyright © 2018 Aleksey Borisov. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
