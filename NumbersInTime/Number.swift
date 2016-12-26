//
//  Number.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 24.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit

class Number: SceneObject {
    
    var startPoint : CGPoint!
    
    init( newValue : Int , myRadius : CGFloat , myStartPoint : CGPoint) {
        super.init(newValue: newValue , myRadius: myRadius)
        
        startPoint = myStartPoint
        
        self.position = startPoint
        
        self.lineWidth = 10
        self.fillColor = SKColor.brown
        
    }
    
    func goBackToStart(){
       self.run(SKAction.move(to: startPoint, duration: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
