//
//  Game.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


//Game errors
enum GameError: String, Error {
    case LogoutError   = "User Logout error"
    case LoginError   = "User Login error"
    case NoLastNameProvided = "Please insert your last name."
    case NoAgeProvided = "Please insert your age."
    case NoEmailProvided = "Please insert your email."
}

struct MyGame {
    var id: Int = 0
    var numbers: [Int] = []
    var targetNumber: Int
}





//Singleton Game class with all game relevant data

class Game {
    
    static let sharedInstance: Game = Game()
    
    
    func createGame() throws -> [String : AnyObject]{
        
        
        let targetNumber: Int = Int(arc4random_uniform(999))
        let numbersArray: [Int] = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,15,1,2,3,4,5,6,7,8,9,10,15,20,20,20,25,50]
        var numbersString: String = ""
        
        
        for  _ in 1...6 {
            let randomIndex : Int = Int(arc4random_uniform(UInt32(numbersArray.count)))
            numbersString = numbersString +  String(numbersArray[randomIndex]) + ";"
        }
        
        let ref = Database.database().reference(fromURL: "https://numbersintime-1fcc3.firebaseio.com/")
        
        let key = ref.child("games").childByAutoId().key
        
       /* let theGame : [String : AnyObject] = [
            "gameId": key as AnyObject,
            "numbers": numbersString as AnyObject,
            "targetNumber": targetNumber as AnyObject,
            "timestamp": ServerValue.timestamp() as AnyObject
        ]*/

        
        let theGame : [String : AnyObject] = [
            "gameId": key as AnyObject,
            "numbers": "1;1;1;1;1;1;" as AnyObject,
            "targetNumber": 6 as AnyObject,
            "timestamp": ServerValue.timestamp() as AnyObject
        ]
        
        let childUpdates = ["/games/\(key)": theGame]
        ref.updateChildValues(childUpdates)
        
        
        return theGame
        
    }
    
        
}
