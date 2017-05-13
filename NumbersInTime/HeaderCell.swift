//
//  HeaderCell.swift
//  NumbersInTime
//
//  Created by miro on 07.05.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
   
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let logoutNotification = Notification.Name.init(rawValue: "logoutAction")
        NotificationCenter.default.post(name: logoutNotification, object: nil)
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}