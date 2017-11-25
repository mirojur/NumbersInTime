//
//  GameScene.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 24.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GameScene: SKScene {  
    
    var gameTimer: Timer!
    
    var numbers = [Number]()
    var gameHistory = [String]()
    var currentGame = [String : AnyObject]()
    
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
    
    
    override func sceneDidLoad() {
        
        if firstInit {
            return
        }
        
        do {
            
            currentGame = try Game.sharedInstance.createGame()
            addNumbers(numbersString: currentGame["numbers"] as! String)
            addTargetNumber(value: currentGame["targetNumber"] as! Int)
            
            initializeModalDialog()
            setupTimer()
            self.firstInit = true
          
        } catch {
            
            
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
    }
    
    //rollback operation
    @objc func handleDoubleTap(){
        
        if(selectedNumber1 != nil){
            selectedNumber1?.handleDoubleTap(scene: self)
            if(selectedNumber1 is Result){
                let selResult : Result = selectedNumber1 as! Result
                
                let resString = selResult.toString()
                gameHistory.remove(at: gameHistory.index(of: resString)!)
                
                numbers.remove(at: (numbers.index(of: selResult))!)
                numbers.append(selResult.number1)
                numbers.append(selResult.number2)
            }
            selectedNumber1 = nil
            selectedNumber2 = nil
            
        }
    }
    
    //gamehistory to string for database
    func gameHistoryToString() -> String {
        var result : String = ""
        for gameSeq in gameHistory {
            result.append(gameSeq)
            result.append(";")
        }
        return result
    }
    
    
    func getGameResult() -> Int {
        
        var result : Int = 0
        var diff : Int = 1000
        
        for res in numbers {
            if( (targetNumber.value - res.value)<diff){
                diff = targetNumber.value - res.value
                result = res.value
            }
        }
        return result
        
    }
    
    //Timer
    @objc func runTimedCode() {
        if(targetNumber.isRunning()){
            targetNumber.tick()
        }else{
            gameOver()
        }
    }
    
    
    func gameOver(){
        gameTimer.invalidate()
        
        let gameId = currentGame["gameId"]
        let gameHistory = gameHistoryToString()
        let player = Auth.auth().currentUser?.email ?? "noUser"
        
        
        let gameResult : [String : AnyObject] = [
            "gameId": gameId as AnyObject,
            "gameHistory": gameHistory as AnyObject,
            "targerNumber": targetNumber.value as AnyObject,
            "result": getGameResult() as AnyObject,
            "resultDiff": abs(targetNumber.value - getGameResult()) as AnyObject,
            "playerId": player as AnyObject,
            "timestamp": ServerValue.timestamp() as AnyObject
        ]
        
        //update local var
        currentGame = gameResult
        
        showResultView()
    }
    
    func saveGameResult(){
        //save result
        let ref = Database.database().reference(fromURL: "https://numbersintime-1fcc3.firebaseio.com/")
        let key = ref.child("gamehistory").childByAutoId().key
        let childUpdates = ["/gamehistory/\(key)": currentGame]
        ref.updateChildValues(childUpdates)
    }
    
    func showResultView() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultController = storyBoard.instantiateViewController(withIdentifier: "ResultController") as! ResultController
        
        resultController.gameResult = currentGame
    
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while (topController.presentedViewController != nil)
            {
                topController = topController.presentedViewController!
            }
            topController.present(resultController, animated: true, completion: nil)
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
                    
                    let firstNumPos: CGPoint = myAddVector(point1: startPoint, point2: CGPoint(x:(width/2.0),y:(1.02*height)))
                    let secondNumPos: CGPoint = myAddVector(point1: firstNumPos, point2: CGPoint(x:(width),y:0))
                    
                    
                    selectedNumber1?.zPosition = 101
                    selectedNumber2?.zPosition = 101
                    
                    
                    if((selectedNumber2?.value)! > (selectedNumber1?.value)!){
                        let tmpNumber : Number = selectedNumber1!
                        selectedNumber1 = selectedNumber2
                        selectedNumber2 = tmpNumber
                    }
                    
                    selectedNumber1?.run(SKAction.move(to: firstNumPos, duration: 0.5))
                    selectedNumber2?.run(SKAction.move(to: secondNumPos, duration: 0.5))
                    
                    self.addChild(modalView)
                    
                    
                    if ( (selectedNumber1?.value)! % (selectedNumber2?.value)! == 0) {
                        self.addChild(divAction)
                    }
                    self.addChild(multiAction)
                    self.addChild(addAction)
                    
                    
                    self.addChild(minusAction)
                    
                    return
                }
            }
            
        }
        
        selectedNumber1?.goBackToStart()
        selectedNumber1 = nil
        
    }
    
    
    
    
    func initializeModalDialog(){
        
        let width  = 0.4*self.size.width
        let height  = 0.46*self.size.height
        let radius = width/2.8
        
        let startPoint = CGPoint(x:-width,y:-height)
        let operationStartPoint = CGPoint(x:0,y:-height+10)
        
        let modalPath = UIBezierPath(rect: CGRect(origin: startPoint, size: CGSize(width: 2*width, height: 1.3*height)))
        
        
        modalView = SKShapeNode(path: modalPath.cgPath)
        modalView.fillColor = UIColor(hex: "#202020")
        modalView.lineWidth = 1
        modalView.zPosition = 100
        
        
        
        //add Actions to the screen
        let divPoint = myAddVector(point1: operationStartPoint, point2: CGPoint(x: (radius + 10),y:radius))
        divAction = DivisionAction(radius: radius)
        divAction.position = divPoint
        divAction.zPosition = 101
        
        let multiPoint = myAddVector(point1: divPoint, point2: CGPoint(x: -(2*radius+10),y:0))
        multiAction = MultiAction(radius: radius)
        multiAction.position = multiPoint
        multiAction.zPosition = 101
        
        let addPoint = myAddVector(point1: multiPoint, point2: CGPoint(x: 0,y: ((2*radius) + 20)))
        addAction = PlusAction(radius: radius)
        addAction.position = addPoint
        addAction.zPosition = 101
        
        let minusPoint = myAddVector(point1: addPoint, point2: CGPoint(x: (2*radius + 10),y:0))
        minusAction = MinusAction(radius: radius)
        minusAction.position = minusPoint
        minusAction.zPosition = 101
        
    }
    
    
    
    
    
    func handleAction(node : SKNode){
        
        
        var op : Int = Operation.NO_OPERATION
        
        if  (node is SKLabelNode && node.parent is PlusAction) ||
            (node is PlusAction) {
            op = Operation.PLU
        }
        
        if  (node is SKLabelNode && node.parent is MinusAction) ||
            (node is MinusAction) {
            op = Operation.MIN
        }
        
        if  (node is SKLabelNode && node.parent is MultiAction) ||
            (node is MultiAction) {
            op = Operation.MUL
        }
        
        if  (node is SKLabelNode && node.parent is DivisionAction) ||
            (node is DivisionAction) {
            op = Operation.DIV
        }
        
        
        if  (op == Operation.NO_OPERATION) {
            
            selectedNumber1?.goBackToStart()
            selectedNumber2?.goBackToStart()
            
            selectedNumber1?.zPosition = 0
            selectedNumber2?.zPosition = 0
            
            
            selectedNumber1 = nil
            selectedNumber2 = nil
            
            removeModalDialog()
            
            return
            
        }
        
        
        
        let result: Result = Result(num1: selectedNumber1!, num2: selectedNumber2!, operation: op, radius: 120.0, position: (selectedNumber1?.startPoint)!)
        
        numbers.append(result)
        numbers.remove(at: (numbers.index(of: selectedNumber1!))!)
        numbers.remove(at: (numbers.index(of: selectedNumber2!))!)
        
        selectedNumber1?.removeFromParent()
        selectedNumber2?.removeFromParent()
        
        selectedNumber1 = nil
        selectedNumber2 = nil
        
        removeModalDialog()
        
        addChild(result)
        gameHistory.append(result.toString())
        
        //if result is the target number game over ...
        if(result.value == targetNumber.value){
            targetNumber.removeFromParent()
            result.run(SKAction.move(to: targetNumber.position, duration: 0.1))
            result.run(SKAction.rotate(byAngle: CGFloat(2*Double.pi), duration: 1.0))
            result.run(SKAction.scale(by: 1.4, duration: 1.0))
            result.run(SKAction.wait(forDuration: 2.1))
            
            gameOver()
            saveGameResult()
        }
        
        
    }
    
    private func removeModalDialog(){
        
        modalView.removeFromParent()
        divAction.removeFromParent()
        multiAction.removeFromParent()
        addAction.removeFromParent()
        minusAction.removeFromParent()
        isInModalMode = false
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
        }
        
        
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
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(selectedNumber1 != nil && !isInModalMode){
            checkIntersection()
        }
        
        print("touchesEnded")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    private func myAddVector(point1: CGPoint, point2: CGPoint) -> CGPoint{
        
        return CGPoint(x: (point1.x + point2.x) , y: (point1.y + point2.y))
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print("touchDown")
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        print("touchMoved")
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        print("touchUp")
        
    }
    
    func setupTimer(){
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    //add the target number to the scene
    func addTargetNumber(value : Int){
        let targetNumberPosition : CGPoint = CGPoint(x:0.0 , y: CGFloat(self.size.height * 0.3))
        targetNumber = TargetNumber(value: value, radius: 150.0, position: targetNumberPosition)
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
    
    
    
    
}
