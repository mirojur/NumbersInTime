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
        self.fillColor = SKColor(red: 114/255, green: 0/255, blue: 0/255, alpha:1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
