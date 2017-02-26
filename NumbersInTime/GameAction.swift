//
//  GameAction.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import SpriteKit

class GameAction: SKShapeNode {
    
    var width: CGFloat = 120
    var symbol: String = ""
    
    init(symbol:String , position: CGPoint) {
        super.init()
        self.symbol = symbol
        
        let path = UIBezierPath(roundedRect: CGRect(origin: position, size: CGSize(width: width, height: width)), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 2.0, height: 2.0))
        
        self.path = path.cgPath
        self.fillColor = UIColor(hex: "#dd4f53")
        self.lineWidth = 7
        
        let numLabelNode: SKLabelNode  = SKLabelNode(text: symbol)
        numLabelNode.fontSize = 40
        numLabelNode.fontColor = SKColor.white
        numLabelNode.position = CGPoint(x: (position.x + width/2.0), y: (position.y + width/2.0))
        numLabelNode.verticalAlignmentMode = .center
        numLabelNode.horizontalAlignmentMode = .center
        
        self.addChild(numLabelNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
