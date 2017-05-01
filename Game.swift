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


//Game errors
enum GameError: String, Error {
    case LogoutError   = "User Logout error"
    case LoginError   = "User Login error"
    case NoLastNameProvided = "Please insert your last name."
    case NoAgeProvided = "Please insert your age."
    case NoEmailProvided = "Please insert your email."
}


//Singleton Game class with all game relevant data

class Game {
    
    static let sharedInstance: Game = Game()
    
    
    public var userName:String!{
        get {
            return UserDefaults.standard.string(forKey: "userName")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
    
    public var userEmail:String!{
        get {
            return UserDefaults.standard.string(forKey: "userEmail")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
    }
    
    public var userID:String!{
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    // Check if User is logged in
    func isUserLoggedIn()-> Bool {
        return Game.sharedInstance.userName != nil
    }
    
    
    // Logout user
    func logout() throws {
        
        do {
            
            try FIRAuth.auth()?.signOut()
            
            Game.sharedInstance.userName = nil
            Game.sharedInstance.userEmail = nil
            Game.sharedInstance.userID = nil
            
        } catch _ as NSError {
            throw GameError.LogoutError
        }
        
    }
    
        
}
