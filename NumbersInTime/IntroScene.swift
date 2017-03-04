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
        
        let height  = 0.1*self.size.height
        let fontSize = 0.08*self.size.width

        let fontColor = UIColor(hex: "#787878")
        
        let localMode: SKLabelNode = SKLabelNode(text: "local training")
        
        localMode.position = CGPoint(x:0,y:height)
        localMode.horizontalAlignmentMode = .center
        localMode.fontSize = fontSize
        localMode.fontColor = fontColor
        
        
        let serverMode: SKLabelNode = SKLabelNode(text: "community mode")
        serverMode.position = myAddVector(point1: localMode.position, point2: CGPoint(x:0,y:-height))
        serverMode.horizontalAlignmentMode = .center
        serverMode.fontSize = fontSize
        serverMode.fontColor = fontColor

        let settingsMode: SKLabelNode = SKLabelNode(text: "settings")
        settingsMode.position = myAddVector(point1: serverMode.position, point2: CGPoint(x:0,y:-height))
        settingsMode.horizontalAlignmentMode = .center
        settingsMode.fontSize = fontSize
        settingsMode.fontColor = fontColor
        
        
        let logout: SKLabelNode = SKLabelNode(text: "logout")
        logout.position = myAddVector(point1: settingsMode.position, point2: CGPoint(x:0,y:-height))
        logout.horizontalAlignmentMode = .center
        logout.fontSize = fontSize
        logout.fontColor = fontColor
        
        
        self.addChild(localMode)
        self.addChild(serverMode)
        self.addChild(settingsMode)
        self.addChild(logout)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first as UITouch!
        let touchLocation = touch?.location(in: self)
        
        let touchedNode = self.atPoint(touchLocation!)
        
        
        if let a = touchedNode as? SKLabelNode {
           
            let value : String = a.text!
            
            switch value {
            case "local training":
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                print(deviceID)
                switchToResultScene()
                
            case "community mode":
                
                
                let status = Reach().connectionStatus()
                switch status {
                case .unknown, .offline:
                    print("Not connected")
                    // create the alert
                    let alert = UIAlertController(title: "no internet connection", message: "device is not connected.. no community amk...", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    // show the alert
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                case .online(.wwan), .online(.wiFi):
                    print("Connected..")
                    
                
                }
                

                
                Game.sharedInstance.setOnlineMode()
                print("Type is community mode")
            case "settings":
                print("Type is settings")
                
                let gameScene = GKScene(fileNamed: "GameScene")!
                let sceneNode = gameScene.rootNode as! GameScene
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }

            case "logout":
                print("Action is logout")
                
                
            default:
                print("Type is unknown")
            }
            
            
        }
        
    }

    func switchToResultScene(){
        
        let gameScene = GKScene(fileNamed: "ResultScene")!
        let sceneNode = gameScene.rootNode as! ResultScene
        // Set the scale mode to scale to fit the window
        sceneNode.scaleMode = .aspectFill
        
        // Present the scene
        if let view = self.view {
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }

    
    private func myAddVector(point1: CGPoint, point2: CGPoint) -> CGPoint{
        
        return CGPoint(x: (point1.x + point2.x) , y: (point1.y + point2.y))
        
    }

}
