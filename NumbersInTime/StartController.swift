//
//  GameViewController.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 24.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class StartController: UIViewController {
    
    let openScorePageNotification = Notification.Name.init(rawValue: "OpenScorePage")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        let scene = GKScene(fileNamed: "IntroScene")!
        let sceneNode = scene.rootNode as! IntroScene
               // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(StartController.showScorePage),
                                                           name: openScorePageNotification,
                                                           object: nil)
                    
                    
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.presentScene(sceneNode)

                    
                }
    }
    
    func showScorePage() {
        print("Game is over. Calling Result Scene")
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
