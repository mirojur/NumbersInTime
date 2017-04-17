//
//  ResultScene.swift
//  NumbersInTime
//
//  Created by miro on 20.02.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//


import SpriteKit
import GameplayKit

class ResultScene: SKScene {
    
    
     override func sceneDidLoad() {
        
        let height  = 0.1*self.size.height
        let fontSize = 0.06*self.size.width
        
        
        
     
        let string1: SKLabelNode = SKLabelNode(text: "game for 222 points")
        
        string1.position = CGPoint(x:0,y:height)
        string1.horizontalAlignmentMode = .center
        string1.fontSize = fontSize
        
        let string2: SKLabelNode = SKLabelNode(text: "your current position: 825")
        
        string2.position = CGPoint(x:0,y:height-70)
        string2.horizontalAlignmentMode = .center
        string2.fontSize = fontSize
        
        let string3: SKLabelNode = SKLabelNode(text: "points: 1825")
        
        string3.position = CGPoint(x:0,y:height-140)
        string3.horizontalAlignmentMode = .center
        string3.fontSize = fontSize
        

        self.addChild(string1)
        
        
        
        let scaleOut = SKAction.scale(by: 1.1, duration: 0.1)
        let scaleIn  = SKAction.scale(by: 0.9, duration: 0.3)
        let rotateUZ  = SKAction.rotate(byAngle: CGFloat(Double.pi/4), duration: 0.4)
        let rotateGUZ  = SKAction.rotate(byAngle: CGFloat(-Double.pi/4), duration: 0.2)

        let sequence = SKAction.sequence([scaleOut,scaleIn,rotateUZ,rotateGUZ])
        
        string1.run(sequence){
            self.addChild(string2)
            
            string2.run(sequence){
               self.addChild(string3)
                string3.run(sequence)
            }
            
            
        }
        
        
    }

}
