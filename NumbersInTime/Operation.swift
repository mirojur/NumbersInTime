//
//  Operation.swift
//  NumbersInTime
//
//  Created by miro on 28.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class Operation {

    static let PLU:Int = 1
    static let MIN:Int = 2
    static let DIV:Int = 3
    static let MUL:Int = 4
    static let NO_OPERATION:Int = -1
    
    
    static func calculate(num1: Number , num2:Number , operation:Int) -> Int {
        switch operation {
        case PLU:
            return num1.value + num2.value
        case MIN:
            return num1.value - num2.value
        case DIV:
            return Int(num1.value / num2.value)
        case MUL:
            return num1.value * num2.value
        
        default:
            return 0
           
        }
    }
    
    static func getOperationSymbol(opValue: Int) -> String {
        switch opValue {
        case PLU:
            return "+"
        case MIN:
            return "-"
        case DIV:
            return "\u{00F7}"
        case MUL:
            return "\u{00D7}"
            
        default:
            return ""
            
        }
    }

}
