//
//  Result.swift
//  NumbersInTime
//
//  Created by miro on 28.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import SpriteKit

class Result: Number {
    
    var number1 : Number
    var number2 : Number
    var operation : Int
    
    
    init(num1:Number , num2:Number , operation:Int , radius : CGFloat , position : CGPoint) {
       
        number1 = num1
        number2 = num2
        self.operation = operation
        
        let val : Int = Operation.calculate(num1: num1, num2: num2, operation: operation)
        
        super.init(value:val , radius: radius, position: position)
        
        self.fillColor = UIColor(hex: "#a6a6a6")
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func handleDoubleTap(scene: SKScene) {
        
        scene.addChild(number1)
        scene.addChild(number2)
        
        self.removeFromParent()
        
        number1.goBackToStart()
        number2.goBackToStart()
    }
    
    func toString() -> String {
        
        var result : String = ""
        
        result.append(String(number1.value))
        result.append(Operation.getOperationSymbol(opValue: operation))
        result.append(String(number2.value))
        result.append("=")
        result.append(String(value))
        
        return result
        
    }

}
