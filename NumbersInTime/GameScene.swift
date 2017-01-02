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
    
    var sceneNumbers = [Number]()
    var firstInit : Bool = false
    
    var targetNumber : TargetNumber!

    var wNumber : CGFloat = 0.0
    var wTargetNumber : CGFloat = 0.0
    
    
    private var selectedNumber : Number?
    
    
    override func sceneDidLoad() {
        
        if firstInit {
            return
        }
        
        
        // Create target number
        
        wNumber  = self.size.width * 0.15
        wTargetNumber  = self.size.width * 0.2
        let targetNumberPosition : CGPoint = CGPoint(x:0 - wTargetNumber , y: (self.size.height*0.5) - (2.8*wTargetNumber))
        
        // Target number shape node
        targetNumber = TargetNumber(newValue: 255, myRadius: wTargetNumber)
        targetNumber.position = targetNumberPosition
        self.addChild(targetNumber)
        
        
        
        
        
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
       
        
        // init timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        self.firstInit = true
 
    }
    
    func runTimedCode() {
        
        if(targetNumber.isRunning()){
            self.targetNumber.tick()
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
        
    }
}
