//
//  CancelAction.swift
//  NumbersInTime
//
//  Created by miro on 05.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class CancelAction: GameAction {

    
    init(position: CGPoint) {
        super.init(symbol: "\u{232B}", position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
