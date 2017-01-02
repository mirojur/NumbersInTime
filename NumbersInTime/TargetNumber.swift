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
    
    init( newValue : Int , radius : CGFloat , position : CGPoint) {
        super.init(newValue: newValue , myRadius: radius)
        self.lineWidth = 5
        self.fillColor = SKColor(red: 114/255, green: 0/255, blue: 0/255, alpha:1.0)
        self.seconds = 0
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func path(radius: CGFloat) -> CGMutablePath {
        let path: CGMutablePath = CGMutablePath()
        CGPathAddArc(path, nil, 0.0, 0.0, radius, 0.0, CGFloat(2.0 * M_PI), true)
        return path
    }
    
    
    func tick(){
    
        seconds = seconds + 1
        
        let mycenter = CGPoint(x:self.frame.midX,y:self.frame.midY)
        let endAngle = CGFloat(2 * M_PI * Double(seconds)/60.0)
        let newPath = UIBezierPath(arcCenter: mycenter, radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        
        
        let pattern : [CGFloat] = [2.0, 2.0]
        newPath.setLineDash(pattern, count: 2, phase: 0)
        
        self.path = newPath.cgPath
        self.strokeColor = UIColor.brown
       
        
    }
    
    func isRunning () -> Bool {
        
        if(seconds < 60){
            return true
        } else {
            return false
        }
        
    }

}
