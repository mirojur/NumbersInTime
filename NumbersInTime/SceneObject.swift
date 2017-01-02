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
    var timer = Timer()
    
   
    
    init( newValue : Int , myRadius : CGFloat) {
        super.init()
       
        value = newValue
        radius = myRadius
        let mycenter = CGPoint(x:self.frame.midX,y:self.frame.midY)
        
        let mypath = UIBezierPath(arcCenter: mycenter, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        self.path = mypath.cgPath
                
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
