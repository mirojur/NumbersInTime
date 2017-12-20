//
//  TargetNumber.swift
//  NumbersInTime
//
//  Created by Miroslav Juric on 25.11.16.
//  Copyright © 2016 Miroslav Juric. All rights reserved.
//

import SpriteKit

class TargetNumber: SceneObject {
    
    var seconds : Int = 0
    
    init( value : Int , radius : CGFloat , position : CGPoint) {
        super.init(number: value,radius: radius,position: position)
        self.lineWidth = 20
        //self.fillColor = SKColor(red: 114/255, green: 0/255, blue: 0/255, alpha:1.0)
        self.fillColor = .clear
        self.seconds = 0
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    func tick(){
    
        seconds = seconds + 1
        
        let endAngle = CGFloat(2 * Double.pi * Double(seconds)/60.0)
        self.path = getLinePath(endAngle: endAngle).cgPath
        
 
        if(seconds<=30){
            self.strokeColor = UIColor.green
            
        }
        if(seconds>30 && seconds<45){
            self.strokeColor = SKColor(red: 255/255, green: 255/255, blue: 107/255, alpha:0.8)
        }
        
        if(seconds >= 45){
            self.strokeColor = SKColor(red: 255/255, green: 10/255, blue: 10/255, alpha:0.8)
        }
        
    }
    
    func tickToEnd(){
        
        while (seconds < 60 ) {
            tick()
        }
        
        
    }
    
   
    func getSegmentPath(endAngle : CGFloat) -> UIBezierPath {
        let newPath = UIBezierPath()
        newPath.move(to: CGPoint(x:0,y:0))
        newPath.addLine(to: CGPoint(x:radius,y:0))
        newPath.addArc(withCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        newPath.addLine(to: CGPoint.zero)
        newPath.close()
        return newPath
    }
    
    
    func getLinePath(endAngle : CGFloat) -> UIBezierPath {
        let newPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        return newPath
    }
    
    
    func isRunning () -> Bool {
        
        if(seconds < 60){
            return true
        } else {
            return false
        }
        
    }

}
