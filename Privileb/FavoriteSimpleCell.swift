//
//  FavoriteSimpleCell.swift
//  Privileb
//
//  Created by SSS on 6/26/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class FavoriteSimpleCell: UITableViewCell {

    @IBOutlet weak var ultimateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var superVisedLabel: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
