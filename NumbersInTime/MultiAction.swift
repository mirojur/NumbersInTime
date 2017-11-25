//
//  MultiAction.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class MultiAction: GameAction {

   
    init(radius: CGFloat) {
        super.init(symbol: "\u{00D7}", radius: radius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
