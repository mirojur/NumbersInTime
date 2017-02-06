//
//  Game.swift
//  NumbersInTime
//
//  Created by miro on 04.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class Game {
    
    static let ONLINE_MODE: Int = 3
    static let OFFLINE_MODE: Int = 2
    
    var gameModus:Int
   
    // Can't init is singleton
    private init() {
    
        // server mode
        // connect to server and get all relevant games
        
        
        
        // local mode
        //generate local games
        gameModus = Game.OFFLINE_MODE
    
    }
    
    //MARK: Shared Instance
    
    static let sharedInstance: Game = Game()
    
    //MARK: Local Variable
    
    var gameStringsArray : [String] = []

    
}
