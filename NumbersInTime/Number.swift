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
    
    init( value : Int , radius : CGFloat , position : CGPoint) {
        super.init(number: value , radius: radius, position: position)
        
        self.startPoint = position
    
        self.lineWidth = 10
        self.fillColor = UIColor(hex: "#ff5218")
    }
    
       
    func goBackToStart(){
       self.run(SKAction.move(to: startPoint, duration: 0.5))
        self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
