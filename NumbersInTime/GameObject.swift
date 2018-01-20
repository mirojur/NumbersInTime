//
//  GameObject.swift
//  NumbersInTime
//
//  Created by Juric, Miroslav (059) on 13.01.18.
//  Copyright © 2018 Miroslav Juric. All rights reserved.
//

import Foundation
import FirebaseDatabase



struct  GameObject : Encodable{
    
    var gameId : String = ""
    var numbers : String = ""
    var playerId : String = ""
    var gameHistory : String = ""
    var result : Int = -1
    var resultDiff : Int = -1
    var targetNumber : Int = -1
    var timestamp : Double = 0.0
   
    init?(json: [String: Any]) {
        self.gameId = (json["gameId"] as? String)!
        self.numbers = (json["numbers"] as? String)!
        self.playerId = (json["playerId"] as? String)!
        self.gameHistory = (json["gameHistory"] as? String)!
        self.result = (json["result"] as? Int)!
        self.resultDiff = (json["resultDiff"] as? Int)!
        self.targetNumber = (json["targetNumber"] as? Int)!
        self.timestamp = (json["timestamp"] as? Double)!
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
                                  "playerId":self.playerId,
                                  "gameHistory":self.gameHistory,
                                  "result":self.result,
                                  "resultDiff":self.resultDiff,
                                  "timestamp": [".sv": "timestamp"]]
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
    

}
