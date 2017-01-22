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
    
    var counter: Int = 0
    
    var isInModalMode : Bool = false

    
    var selectedNumber1 : Number?
    var selectedNumber2 : Number?
    
    var divAction: DivisionAction!
    var multiAction: MultiAction!
    var addAction: PlusAction!
    var minusAction: MinusAction!
    var modalView: SKShapeNode!
    var cancelAction: CancelAction!
    
    
    override func sceneDidLoad() {
        
        if firstInit {
            return
        }
        
        
        addTargetNumber(value: 100)
        
        addNumbers(numbersString: "25;4;2;1;22;50")
        
        initializeModalDialog()
        
        setupTimer()
        
        
        self.firstInit = true
 
    }
    
    
    
    func setupTimer(){
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    //add the target number to the scene
    func addTargetNumber(value : Int){
        
        let targetNumberPosition : CGPoint = CGPoint(x:0.0 , y: CGFloat(self.size.height * 0.3))
        targetNumber = TargetNumber(value: 255, radius: 150.0, position: targetNumberPosition)
        
        self.addChild(targetNumber)
        
    }
    
    
    
    //add six numbers to the scene
    func addNumbers(numbersString : String){
        
        let xCoords : [CGFloat] =  [-CGFloat(self.size.height * 0.12) , CGFloat(self.size.height * 0.12)]
        let yCoords : [CGFloat] = [-CGFloat(self.size.height * 0.35) , -CGFloat(self.size.height * 0.15) , CGFloat(self.size.height * 0.05)]
        
        
        var numbersStringArray:[String] = numbersString.components(separatedBy: ";")
   
        var counter  = 0
        
            for i in 0...2 {
                
                for j in 0...1{
                    
                    let currentPos : CGPoint = CGPoint(x: xCoords[j] , y: yCoords[i])
                   
                    let num = Int(numbersStringArray[counter])
                    let number = Number(value : num! , radius: 120.0 , position: currentPos)
                    
                    number.position = currentPos
                    
                    self.addChild(number)
                    self.numbers.append(number)
                    counter  = counter + 1
                }
            }
       
    }
    
    //Timer
    @objc func runTimedCode() {
        
        if(targetNumber.isRunning()){
            targetNumber.tick()
        }else{
            gameTimer.invalidate()
        }
        
    }
    
    //check if selected number intersect with some other shape..
    private func checkIntersection(){
        
        
        for node: Number in numbers {
            
            if(!((selectedNumber1?.isEqual(to: node))!) && (selectedNumber1?.intersects(node))!){
                
                
                let xDist = ((selectedNumber1?.position.x)! - node.position.x)
                let yDist = ((selectedNumber1?.position.y)! - node.position.y)
                let distance = sqrt((xDist * xDist) + (yDist * yDist))
                
                if(distance < (selectedNumber1?.radius)!){
                    isInModalMode = true
                    selectedNumber2 = node
                    
                    let width  = 0.4*self.size.width
                    let height  = 0.4*self.size.height
                    let startPoint = CGPoint(x:-width,y:-height)
                    
                    let firstNumPos: CGPoint = myAddVector(point1: startPoint, point2: CGPoint(x:(width/2.0),y:(0.75*height)))
                    let secondNumPos: CGPoint = myAddVector(point1: firstNumPos, point2: CGPoint(x:(width),y:0))
                    
                    
                    selectedNumber1?.zPosition = 101
                    selectedNumber2?.zPosition = 101
                    
                    
                    if((selectedNumber1?.value)! >= (selectedNumber2?.value)!){
                        selectedNumber1?.run(SKAction.move(to: firstNumPos, duration: 0.5))
                        selectedNumber2?.run(SKAction.move(to: secondNumPos, duration: 0.5))
                    }else{
                        selectedNumber1?.run(SKAction.move(to: secondNumPos, duration: 0.5))
                        selectedNumber2?.run(SKAction.move(to: firstNumPos, duration: 0.5))
                    }
                    
                    
                    self.addChild(modalView)
                    self.addChild(divAction)
                    self.addChild(multiAction)
                    self.addChild(addAction)
                    self.addChild(minusAction)
                    self.addChild(cancelAction)

                    return
                }
            }
            
        }
        
        selectedNumber1?.goBackToStart()
        selectedNumber1 = nil
        
    }
    
    
    
    
    func initializeModalDialog(){
        
        let width  = 0.4*self.size.width
        let height  = 0.4*self.size.height
        let startPoint = CGPoint(x:-width,y:-height)
        
        let modalPath = UIBezierPath(roundedRect: CGRect(origin: startPoint, size: CGSize(width: 2*width, height: 2*width)), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 12.0, height: 12.0))
        
        
        modalView = SKShapeNode(path: modalPath.cgPath)
        modalView.fillColor = UIColor.brown
        modalView.lineWidth = 5
        modalView.zPosition = 100
        
        
        
        //add Actions to the screen
        let divPoint = myAddVector(point1: startPoint, point2: CGPoint(x:(width/2.0),y:(width/2.0)))
        divAction = DivisionAction(position: divPoint)
        divAction.zPosition = 101
        
        let multiPoint = myAddVector(point1: divPoint, point2: CGPoint(x:100.0,y:(0)))
        multiAction = MultiAction(position: multiPoint)
        multiAction.zPosition = 101
        
        let addPoint = myAddVector(point1: multiPoint, point2: CGPoint(x:100.0,y:(0)))
        addAction = PlusAction(position: addPoint)
        addAction.zPosition = 101
        
        let minusPoint = myAddVector(point1: addPoint, point2: CGPoint(x:100.0, y:0))
        minusAction = MinusAction(position: minusPoint)
        minusAction.zPosition = 101
        
        let cancelPoint = myAddVector(point1: minusPoint, point2: CGPoint(x:0.0, y:-100.0))
        cancelAction = CancelAction(position: cancelPoint)
        cancelAction.zPosition = 101
        
    }
    
    
    func rollbackMerge(){
        
    }

    
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    func handleAction(node : SKNode){
        
        
        //
        if  (node is SKLabelNode && node.parent is CancelAction) ||
            (node is CancelAction) {
            
            selectedNumber1?.goBackToStart()
            selectedNumber2?.goBackToStart()
            
            selectedNumber1?.zPosition = 0
            selectedNumber2?.zPosition = 0
            
            selectedNumber1?.run(SKAction.scale(by: 1.0, duration: 0.2))
            selectedNumber2?.run(SKAction.scale(by: 1.0, duration: 0.2))
            
            modalView.removeFromParent()
            divAction.removeFromParent()
            multiAction.removeFromParent()
            addAction.removeFromParent()
            minusAction.removeFromParent()
            cancelAction.removeFromParent()
            
            selectedNumber1 = nil
            selectedNumber2 = nil
            
            isInModalMode = false

            
        }
        
        if  (node is SKLabelNode && node.parent is PlusAction) ||
            (node is PlusAction) {
            
        }
        
        if  (node is SKLabelNode && node.parent is MinusAction) ||
            (node is MinusAction) {
            
        }
        
        if  (node is SKLabelNode && node.parent is MultiAction) ||
            (node is MultiAction) {
            
        }
        
        if  (node is SKLabelNode && node.parent is DivisionAction) ||
            (node is DivisionAction) {
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!
        let touchLocation = touch?.location(in: self)
        
        let touchedNode = self.atPoint(touchLocation!)
        
        
        
        // no move on numbers when in modal mode
        if(isInModalMode){
            handleAction(node: touchedNode)
            return
        }
        
        if let a = touchedNode as? Number {
            selectedNumber1 = a
            
        }
        
        if touchedNode is SKLabelNode && touchedNode.parent is Number{
            selectedNumber1 = touchedNode.parent as! Number?
            //selectedNumber?.run(pulse)
            
        }
        
       
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!
        let touchLocation = touch?.location(in: self)
        let halfWidth = self.size.width/2.0
        let halfHeight = self.size.height/2.0
        
        
        if (selectedNumber1 != nil && !isInModalMode) {
        
            let currentRadius = (selectedNumber1?.radius)!
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
            
            selectedNumber1?.position = newPosition
            
        }
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(selectedNumber1 != nil && !isInModalMode){
           checkIntersection()
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
    }
    
    private func myAddVector(point1: CGPoint, point2: CGPoint) -> CGPoint{
        
        return CGPoint(x: (point1.x + point2.x) , y: (point1.y + point2.y))
        
    }
    
}
