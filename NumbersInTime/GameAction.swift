//
//  GameAction.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import SpriteKit

class GameAction: SKShapeNode {
    
    var symbol: String = ""
    
    init(symbol:String , radius: CGFloat) {
        super.init()
        self.symbol = symbol
        
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
            

        
        self.path = path.cgPath
        self.fillColor = UIColor(hex: "#ff9600")
        self.lineWidth = 0
        
        
        let numLabelNode: SKLabelNode  = SKLabelNode(text: symbol)
        numLabelNode.fontName = numLabelNode.fontName! + "-Bold"
        numLabelNode.fontSize = 55
        numLabelNode.fontColor = SKColor.white
        //numLabelNode.position = CGPoint(x: (position.x + width/2.0), y: (position.y + width/2.0))
        numLabelNode.verticalAlignmentMode = .center
        numLabelNode.horizontalAlignmentMode = .center
        
        self.addChild(numLabelNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
