//
//  SceneObject.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 25.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit

class SceneObject: SKShapeNode {
    
    var value : Int! = 0
    var numLabelNode : SKLabelNode!
    var selectedInGame : Bool! =  false
    var radius : CGFloat! = 0
    
   
    
    init( newValue : Int , myRadius : CGFloat) {
        super.init()
       
        value = newValue
        radius = myRadius
        
        let diameter = radius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint(x:0,y:0) , size: CGSize(width: diameter, height: diameter)), transform: nil)
        
        
                
        numLabelNode  = SKLabelNode(text: String(value))
        numLabelNode.fontSize = 100
        numLabelNode.fontColor = SKColor.white
        numLabelNode.position = CGPoint(x:self.frame.midX  ,y:self.frame.midY )
        numLabelNode.verticalAlignmentMode = .center
        numLabelNode.horizontalAlignmentMode = .center
        
        self.addChild(numLabelNode)
        
    }
    
    func getColor () -> SKColor {
        return SKColor.brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
