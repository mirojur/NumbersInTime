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
    
   
    
    init( number : Int , radius : CGFloat , position : CGPoint) {
        super.init()
       
        self.value = number
        self.radius = radius
        
        
        let mypath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        self.lineWidth = 15
        self.lineCap = .round
        
        self.path = mypath.cgPath
        self.position = position
                
        self.addLabel()
    }
    
    
    
    
    private func addLabel(){
        
        numLabelNode  = SKLabelNode(text: String(value))
        numLabelNode.fontSize = 100
        numLabelNode.fontColor = SKColor.white
        numLabelNode.position = CGPoint.zero
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

    func handleDoubleTap (scene:SKScene){
                
    }

}
