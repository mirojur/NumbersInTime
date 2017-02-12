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

class Game {
    
    let defaults = UserDefaults.standard
    
    static let ONLINE_MODE: Int = 3
    static let OFFLINE_MODE: Int = 2
    
    var gameModus:Int = 0{
        didSet {
               defaults.set(gameModus, forKey: "gameModus")
        }
    }
    
    var userName:String = ""{
        didSet {
            defaults.set(userName, forKey: "userName")
        }
    }
  
    
    static let sharedInstance: Game = Game()
    
    var gameStringsArray : [String] = []

    func setOnlineMode(){
        self.gameModus = Game.ONLINE_MODE
    }
    
    func getGamesFromServer(){
        
        
    }
    
    
    
       
}
