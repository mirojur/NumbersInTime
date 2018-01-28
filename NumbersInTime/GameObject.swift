//
//  GameObject.swift
//  NumbersInTime
//
//  Created by Juric, Miroslav (059) on 13.01.18.
//  Copyright © 2018 Miroslav Juric. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth



class  GameObject : Encodable{
    
    var score : Int = 0
    
    var isMyGame : Bool = false
    
    var gameId : String = ""
    var numbers : String = ""
    var targetNumber : Int = -1
    
    var playerId : String = ""
    var gameHistory : String = ""
    var result : Int = -1
    var resultDiff : Int = -1
    var timestamp : Double = 0.0
    var playerName : String = ""
    var playerImageUrl : String = ""
    
    
    var playerId2 : String = ""
    var gameHistory2 : String = ""
    var result2 : Int = -1
    var resultDiff2 : Int = -1
    var timestamp2 : Double = 0.0
    var playerName2 : String = ""
    var playerImageUrl2 : String = ""
    
    
    init?(json: [String: Any]) {
        self.gameId = (json["gameId"] as? String)!
        self.numbers = (json["numbers"] as? String)!
        self.targetNumber = (json["targetNumber"] as? Int)!
        self.timestamp = (json["timestamp"] as? Double)!
        
        self.playerId = (json["playerId"] as? String)!
        self.gameHistory = (json["gameHistory"] as? String)!
        self.result = (json["result"] as? Int)!
        self.resultDiff = (json["resultDiff"] as? Int)!
        self.playerName = (json["playername"] as? String)!
        self.playerImageUrl = (json["playerimageurl"] as? String)!
        
       
    }
    
    
    init?() {
        
        let targetNumber: Int = Int(arc4random_uniform(999))
        let numbersArray: [Int] = [1,2,3,4,5,6,7,8,9,10,25,1,2,3,4,5,6,7,8,9,10,15,20,25,1,2,3,4,5,6,7,8,9,10,15,20,25,1,2,3,4,5,6,7,8,9,10,15,20,25,1,2,3,4,5,6,7,8,9,10,15,20,25,]
        
        var numbersString: String = ""
        
        
        for  _ in 1...6 {
            let randomIndex : Int = Int(arc4random_uniform(UInt32(numbersArray.count)))
            numbersString = numbersString +  String(numbersArray[randomIndex]) + ";"
        }
        
        
        let ref = Database.database().reference()
        let key = ref.child("games").childByAutoId().key
        
        self.gameId = key
        self.numbers = numbersString
        self.targetNumber = targetNumber
        
        if(( Auth.auth().currentUser ) != nil){
            self.playerName = Auth.auth().currentUser?.displayName ?? (Auth.auth().currentUser?.email)!
            self.playerId = (Auth.auth().currentUser?.uid)!
            
            if((Auth.auth().currentUser?.photoURL) != nil){
                self.playerImageUrl = (Auth.auth().currentUser?.photoURL?.absoluteString)!
            }
        }else {
            self.playerName = "noUser"
        }
        
    }
    
    
    public func saveGame()  {
        let ref = Database.database().reference()
        let childUpdates = ["/games/\(self.gameId)": self.convertToGameDictionary()]
        ref.updateChildValues(childUpdates)
    }
    
    public func saveGameHistory()  {
        let ref = Database.database().reference()
        let key = ref.child("gamehistory").childByAutoId().key
        let gameHistoryUpdate = ["/gamehistory/\(key)": self.convertToGameHistoryDictionary()]
        ref.updateChildValues(gameHistoryUpdate)
        
    }
    
    public func saveOnlineGameHistory()  {
        let ref = Database.database().reference()
        let key = ref.child("gamehistory").childByAutoId().key
        let gameHistoryUpdate = ["/gamehistory/\(key)": self.convertOnlineGameHistoryDictionary()]
        ref.updateChildValues(gameHistoryUpdate)
        
    }
    
    func convertToGameDictionary() -> [String : Any] {
        let dic: [String: Any] = ["gameId":self.gameId,
                                  "numbers":self.numbers,
                                  "timestamp": [".sv": "timestamp"],
                                  "targetNumber":self.targetNumber]
        return dic
    }
    
    func convertToGameHistoryDictionary() -> [String : Any] {
        let dic: [String: Any] = ["gameId":self.gameId,
                                  "numbers":self.numbers,
                                  "targetNumber":self.targetNumber,
                                  "timestamp": [".sv": "timestamp"],
                                  "playerId":self.playerId,
                                  "gameHistory":self.gameHistory,
                                  "result":self.result,
                                  "resultDiff":self.resultDiff,
                                  "playername":self.playerName,
                                  "playerimageurl":self.playerImageUrl]
        return dic
    }
    
    func convertOnlineGameHistoryDictionary() -> [String : Any] {
        let dic: [String: Any] = ["gameId":self.gameId,
                                  "numbers":self.numbers,
                                  "targetNumber":self.targetNumber,
                                  "timestamp": [".sv": "timestamp"],
                                  "playerId":self.playerId2,
                                  "gameHistory":self.gameHistory2,
                                  "result":self.result2,
                                  "resultDiff":self.resultDiff2,
                                  "playername":self.playerName2,
                                  "playerimageurl":self.playerImageUrl2]
        return dic
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date as Date)
    }
    
    
    func saveGameResult(){
        
        calculatePoints()
        saveScore()
        
        if(isMyGame){
            self.saveGameHistory()
        }else{
            self.playerId = self.playerId2
            self.gameHistory = self.gameHistory2
            self.playerImageUrl = self.playerImageUrl2
            self.playerName = self.playerName2
            self.result = self.result2
            self.resultDiff = self.resultDiff2
            
            self.saveOnlineGameHistory()
        }
        
        
    }
    
    
    private func calculatePoints(){
        if(isMyGame){
            if(self.resultDiff == 0){
                score = 10
            }
        }else{
            
            //aktuelle spieler ist der player 2, also 2er daten checken
            
            if ( self.resultDiff > self.resultDiff2 ){
                score = 15
            }else if(self.resultDiff == self.resultDiff2 ){
                score = 10
            }
        }
    }
    
    
    private func saveScore(){
        
        let ref = Database.database().reference()
        var user = "noUser"
        var userEmail = ""
      
        if(( Auth.auth().currentUser ) != nil){
            user = (Auth.auth().currentUser?.uid)!
            userEmail = (Auth.auth().currentUser?.email)!
        }
        
        
        
        //update score only if there is something to update
        if ( self.score != 0 ){
            
            //get user last score from database
            ref.child("score").observeSingleEvent(of: .value, with: {
                
                (snapshot) in
                
                if snapshot.hasChild(user){
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    
                    if( value != nil ){
                        let userlastvalues = value?[user] as? NSDictionary
                        self.score = (userlastvalues?["points"] as? Int)! + self.score
                    }
                    
                }
                
                let scoreData : [String : AnyObject] = [
                    "points": self.score as AnyObject,
                    "email": userEmail as AnyObject,
                    "timestamp": ServerValue.timestamp() as AnyObject
                ]
                
                let scoreHistoryUpdate = ["/score/\(user)": scoreData]
                ref.updateChildValues(scoreHistoryUpdate)
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
}
