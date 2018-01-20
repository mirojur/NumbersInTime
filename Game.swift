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
    
    var onlineGames = [GameObject] ()
    
    func createGame() -> GameObject{
        
        let gameObject:GameObject = GameObject()!
        gameObject.saveGame()
        return gameObject
        
    }
    
    func userHasOnlineGames() -> Bool {
        return !onlineGames.isEmpty
    }
    
    
    func getOnlineGame() -> GameObject {
        let result : GameObject = self.onlineGames[0]
        return result
    }
    
    
    func getGamesFromServer() {
        
        let ref = Database.database().reference()
        
        ref.child("gamehistory").observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            let children = snapshot.children
            var yourArray = [String: Any]()
            let user = (Auth.auth().currentUser?.uid)!
            
            var playedGames = UserDefaults.standard.object(forKey: user) as? [String] ?? [String]()
            
            while let rest = children.nextObject() as? DataSnapshot, let value = rest.value {
                
                yourArray = (value as! [String: AnyObject])
                
                let playerId : String = yourArray["playerId"] as! String
                let gameId:String = yourArray["gameId"] as! String
                
                //check if user play this game
                if(playerId == user &&  !(playedGames.contains(gameId))){
                    playedGames.append(gameId)
                    UserDefaults.standard.set(playedGames, forKey: user)
                }
                
                //if game is not into the local array
                if(playerId != user  && self.onlineGames.filter{$0.gameId == gameId}.count == 0){
                    let newOnlineGame = GameObject(json: yourArray)
                    self.onlineGames.append(newOnlineGame!)
                }
                
            }
            
        })
        
    }
    
    
}
