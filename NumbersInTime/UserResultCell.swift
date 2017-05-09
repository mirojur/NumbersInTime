//
//  UserResultCell.swift
//  NumbersInTime
//
//  Created by miro on 07.05.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class UserResultCell: UITableViewCell {

    @IBOutlet weak var lost: UILabel!
    @IBOutlet weak var draw: UILabel!
    @IBOutlet weak var won: UILabel!
    @IBOutlet weak var gamePlayed: UILabel!
    @IBOutlet weak var currentPlacement: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
