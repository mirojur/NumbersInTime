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

    @IBOutlet weak var gameCommentLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var playerAvatar: UIImageView!
  
    @IBAction func playGame(_ sender: Any) {
        
        
        func showPlayInCommunityView() {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameController = storyBoard.instantiateViewController(withIdentifier: "GameController") as! GameController
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while (topController.presentedViewController != nil)
                {
                    topController = topController.presentedViewController!
                }
                topController.present(gameController, animated: true, completion: nil)
            }
        }
        
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
            
            self.gameCommentLabel.text = "this is your game"
            self.playerName.text = ""
            self.timestampLabel.text = ""
            self.resultLabel.text = "good luck!"
        }
        
        Game.sharedInstance.currentGame =  self.gameResult

        //bild des users laden 
        if(!gameResult.playerImageUrl.isEmpty){
            
            let data = try? Data(contentsOf: (URL(string: gameResult.playerImageUrl))!)
            
            if(( data ) != nil) {
                playerAvatar.image = UIImage(data: data!)
            }else {
                playerAvatar.image = UIImage(named: "avatar")
            }
        }else {
            playerAvatar.image = UIImage(named: "avatar")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
