//
//  CommunityViewController.swift
//  NumbersInTime
//
//  Created by Juric, Miroslav (059) on 07.01.18.
//  Copyright © 2018 Miroslav Juric. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    
    
    var gameResult: GameObject! = nil
    var playingOwnGame : Bool = false

    @IBAction func playThisGame(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //try to loat games from server
        Game.sharedInstance.getGamesFromServer()
        
        if ( Game.sharedInstance.userHasOnlineGames()){
           self.gameResult = Game.sharedInstance.getOnlineGame()
            
        } else {
            self.gameResult = Game.sharedInstance.createGame()
            self.playingOwnGame = true
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
