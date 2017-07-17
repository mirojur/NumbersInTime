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
            
            try Auth.auth().signOut()
            
            Game.sharedInstance.userName = nil
            Game.sharedInstance.userEmail = nil
            Game.sharedInstance.userID = nil
            
        } catch _ as NSError {
            throw GameError.LogoutError
        }
        
    }
    
    
    func createGame() throws -> [String : AnyObject]{
        
        
        let targetNumber: Int = Int(arc4random_uniform(999))
        let numbersArray: [Int] = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,10,15,10,15,20,20,20,25,50]
        var numbersString: String = ""
        
        
        for  _ in 1...6 {
            
            
            let randomIndex : Int = Int(arc4random_uniform(UInt32(numbersArray.count)))
            numbersString = numbersString +  String(numbersArray[randomIndex]) + ";" 
            
            
        }
        
        let userId = Game.sharedInstance.userID ?? "noUser"
        
        
        let theGame : [String : AnyObject] = [
            "player": userId as AnyObject,
            "numbers": numbersString as AnyObject,
            "targetNumber": targetNumber as AnyObject
        ]
        
        let firebaseRef = Database.database().reference()
        
        let key = firebaseRef.child("games").childByAutoId().key
        
        let childUpdates = ["/games/\(key)": theGame]
       
        firebaseRef.updateChildValues(childUpdates)
        
        return theGame
        
    }
    
        
}
