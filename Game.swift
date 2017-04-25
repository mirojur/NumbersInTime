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



class Game {
    
     
    
    public static var userName:String!{
        get {
            return UserDefaults.standard.string(forKey: "userName")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
  
    public static var userEmail:String!{
        get {
            return UserDefaults.standard.string(forKey: "userEmail")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var userID:String!{
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userID")
            UserDefaults.standard.synchronize()
        }
    }

    
    static let sharedInstance: Game = Game()
    
    var gameStringsArray : [String] = []

    
    func isUserLoggedIn()-> Bool {
      return Game.userName != nil
    }
    
    func logout() throws {
        
        do {
            
            try FIRAuth.auth()?.signOut()
            Game.userName = nil
            Game.userEmail = nil 
            
        } catch _ as NSError {
            throw GameError.LogoutError
        }
        
    }
    
    func getGamesFromServer(){
        
        
    }
    
    
    
       
}
