//
//  RideHistoryTableViewCell.swift
//  autolayout
//
//  Created by Hun Zaw on 5/7/19.
//  Copyright © 2019 Hun Zaw. All rights reserved.
//

import UIKit

class RideHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
