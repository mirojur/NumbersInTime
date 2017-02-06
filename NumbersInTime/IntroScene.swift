//
//  IntroScene.swift
//  NumbersInTime
//
//  Created by miro on 29.01.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import SpriteKit
import GameplayKit

class IntroScene: SKScene {
    
    override func sceneDidLoad() {
        
        let localMode: SKLabelNode = SKLabelNode(text: "Local Mode")
        let serverMode: SKLabelNode = SKLabelNode(text: "Community Mode")
        
        localMode.position = CGPoint(x:-100,y:100)
        serverMode.position = CGPoint(x:-100,y:-100)
        
        self.addChild(localMode)
        self.addChild(serverMode)
        
    }

}
