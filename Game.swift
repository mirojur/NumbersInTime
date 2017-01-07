//
//  Game.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class Game {

    var gameString : String = ""
    var targetNumber : Int!
    
    var selectedNumber1 : Int?
    var selectedNumber2 : Int?
    
    var currentOperation : String?
    
    
    init(gamestring: String){
        self.gameString = gamestring
    }
    
    func setCurrentNumbers(num1 : Int , num2 : Int){
        
    }
    
    func rollbackCurrentAction(){
                
    }
    
    
}
