//
//  TargetNumber.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 25.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit

class TargetNumber: SceneObject {
    
    override init( newValue : Int , myRadius : CGFloat ) {
        super.init(newValue: newValue , myRadius: myRadius)
        
        self.lineWidth = 10
        self.fillColor = SKColor.blue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
