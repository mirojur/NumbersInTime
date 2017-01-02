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
    
    
    var gameTimer: Timer!
    
    var numbers = [Number]()
    var firstInit : Bool = false
    
    var targetNumber : TargetNumber!

    
    private var selectedNumber : Number?
    
    
    override func sceneDidLoad() {
        
        if firstInit {
            return
        }
        
        
        // Create target number
        let targetNumberPosition : CGPoint = CGPoint(x:0.0 , y: CGFloat(self.size.height * 0.3))
        
        // Target number shape node
        targetNumber = TargetNumber(value: 255, radius: 150.0, position: targetNumberPosition)
        self.addChild(targetNumber)
        
        
        
        let xCoords : [CGFloat] =  [-CGFloat(self.size.height * 0.12) , CGFloat(self.size.height * 0.12)]
        let yCoords : [CGFloat] = [-CGFloat(self.size.height * 0.35) , -CGFloat(self.size.height * 0.15) , CGFloat(self.size.height * 0.05)]
        for i in 0...2 {
            
            for j in 0...1{
                
                let currentPos : CGPoint = CGPoint(x: xCoords[j] , y: yCoords[i])
                let number = Number(value : 10, radius: 120.0 , position: currentPos)
                
                number.position = currentPos
                
                self.addChild(number)
                self.numbers.append(number)
            }
        }
       
        
        // init timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        self.firstInit = true
 
    }
    
    func runTimedCode() {
        
        if(targetNumber.isRunning()){
            targetNumber.tick()
        }else{
            gameTimer.invalidate()
        }
        
        
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
        SKAction.sequence([pulseUp, pulseDown])
        
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
        let halfWidth = self.size.width/2.0
        let halfHeight = self.size.height/2.0
        
        print(touchLocation)
        
        if (selectedNumber != nil) {
        
            let currentRadius = (selectedNumber?.radius)!
            var newPosition : CGPoint = touchLocation!
            
            if (newPosition.x - currentRadius < -halfWidth){
                newPosition.x = -halfWidth + currentRadius
            }
            
            if (newPosition.x + currentRadius > halfWidth){
                newPosition.x = halfWidth - currentRadius
            }
            
            if (newPosition.y + currentRadius > halfHeight){
                newPosition.y = halfHeight - currentRadius
            }
            
            if (newPosition.y - currentRadius < -halfHeight){
                newPosition.y = -halfHeight + currentRadius
            }
            
            selectedNumber?.position = newPosition
            
        }
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(selectedNumber != nil){
           selectedNumber?.goBackToStart()
            selectedNumber = nil
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNumber = nil
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
    }
}
