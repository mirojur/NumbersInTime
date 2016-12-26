//
//  GameScene.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 24.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var sceneNumbers = [Number]()
    var firstInit : Bool = false

    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var wNumber : CGFloat = 0.0
    var wTargetNumber : CGFloat = 0.0
    
    
    private var selectedNumber : Number?
    
    
    override func sceneDidLoad() {
        
        if firstInit {
            return
        }
        
        // Create shape node to use during mouse interaction
        
        wNumber  = self.size.width * 0.15
        wTargetNumber  = self.size.width * 0.2
        
        
        print(self.size.width, self.size.height)
        
        let targetNumberPosition : CGPoint = CGPoint(x:0 - wTargetNumber , y: (self.size.height*0.5) - (2.8*wTargetNumber))
        print(targetNumberPosition)
        
        // Target Number
        //let tnumber = TargetNumber(newValue: 255, myRadius: wTargetNumber)
        //tnumber.position = targetNumberPosition
        //self.addChild(tnumber)
        
        
       let shape = SKShapeNode(circleOfRadius: 150)
            
       shape.fillColor =  .clear
       shape.lineWidth = 10
       shape.strokeColor = .darkGray
       
       let myPath = UIBezierPath(arcCenter: CGPoint.zero, radius: -150, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
    
       let pattern = [CGFloat(6.0), CGFloat(20.0)]
       myPath.setLineDash(pattern, count: 2, phase: 0)
       
       shape.path = myPath.cgPath
       shape.position = CGPoint(x: frame.midX, y: frame.midY+300)
        
       addChild(shape)
        
        
        
        let xCoords : [CGFloat] =  [-200.0 , 100]
        let yCoords : [CGFloat] = [-500 , -250 , 0]
        for i in 0...2 {
            
            for j in 0...1{
                
                let currentPos : CGPoint = CGPoint(x: xCoords[j] , y: yCoords[i])
                
                let number = Number(newValue: 10, myRadius: wNumber , myStartPoint: currentPos)
                number.position = currentPos
                self.addChild(number)
                self.sceneNumbers.append(number)
            }
        }
       
       
        self.firstInit = true
 
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let pulseUp = SKAction.scale(by: 1.1, duration: 0.05)
        let pulseDown = SKAction.scale(by: 1.1, duration: 0.05)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        
        let touch = touches.first as UITouch!
        let touchLocation = touch?.location(in: self)
        
        let touchedNode = self.atPoint(touchLocation!)
        
        
        if let a = self.atPoint(touchLocation!) as? Number {
            selectedNumber = a
            //selectedNumber?.run(pulse)
            
        }
        
        if touchedNode is SKLabelNode && touchedNode.parent is Number{
            selectedNumber = touchedNode.parent as! Number?
            //selectedNumber?.run(pulse)
            
        }
        
       
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!
        let touchLocation = touch?.location(in: self)
        let halfWidth = self.size.width/2
        let halfHeight = self.size.height/2
        
        if (selectedNumber != nil) {
            var newPosition : CGPoint = CGPoint(x: (touchLocation?.x)! - (selectedNumber?.radius)!, y: (touchLocation?.y)! - (selectedNumber?.radius)!)
            
            if (newPosition.x < -halfWidth){
                newPosition.x = -halfWidth
            }
            
            if (newPosition.x + (2*wNumber) > halfWidth){
                newPosition.x = halfWidth - (2*wNumber)
            }
            
            if (newPosition.y + (2*wNumber) > halfHeight){
                newPosition.y = halfHeight - (2*wNumber)
            }
            
            if (newPosition.y  < -halfHeight){
                newPosition.y = -halfHeight
            }
            
            selectedNumber?.position = newPosition
            
        }
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(selectedNumber != nil){
           selectedNumber?.goBackToStart()
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNumber = nil
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
