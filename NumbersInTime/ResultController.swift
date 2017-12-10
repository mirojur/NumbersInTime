//
//  ResultControllerViewController.swift
//  NumbersInTime
//
//  Created by miro on 17.09.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ScrollableGraphView

class ResultController: UIViewController, ScrollableGraphViewDataSource{
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var graphSubView: ScrollableGraphView!
    
    
    var gameResult :  [String : AnyObject]  = [:]
    
   
    var lastResults : [Bool] = []

    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLastResults()
        
        graphSubView.dataSource = self
        setupGraph(graphView: graphSubView)
        
        avatar.layer.borderWidth = 1
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        
        
        if(Auth.auth().currentUser==nil){
          
        }
        
        
        if(gameResult["gameHistory"] != nil){
        
            let gameHistory:String = gameResult["gameHistory"] as! String
            let gameSeq = gameHistory.components(separatedBy: ";")
            
            // Do any additional setup after loading the view.
            
            let targetNumber: String =  String(gameResult["targerNumber"] as! Int)
            let myResult: String = String(gameResult["result"] as! Int)
          
            for index in 0...gameSeq.capacity-1{
                let gameSeqText = gameSeq[index]
            }
            
            
            
        }else {
          
        }
        
    }
    
    func getLastResults(){
        var won : Bool = false
        for index in 1...10 {
            let randomIndex : Int = Int(arc4random_uniform(UInt32(300)))
            if(randomIndex < 150 ){
                won = true
            } else {
                won = false
            }
            lastResults.append(won)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        let won : Bool = lastResults[pointIndex]
        
        if( won && plot.identifier == "one"){
               return 10.00
        }
        
        if( !won && plot.identifier == "two" ){
                return 0.00
        }
        
        return -100.00
        
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "game \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return 10
    }
    
    func setupGraph(graphView: ScrollableGraphView) {
        
        // Setup the first line plot.
        let dotPlot = DotPlot(identifier: "one")
        
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointSize = 8.0
        dotPlot.dataPointFillColor = UIColor.green.withAlphaComponent(0.9)
        
        
        let dotPlot2 = DotPlot(identifier: "two")
        
        dotPlot2.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot2.dataPointSize = 8.0
        dotPlot2.dataPointFillColor = UIColor.red.withAlphaComponent(0.9)
       
        
        
        // Customise the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.0)
        referenceLines.referenceLineLabelColor = UIColor.red
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.0)
        
        //referenceLines.absolutePositions = [0, 10]
        
        graphView.topMargin = 30.0
        graphView.bottomMargin = 10.0
        graphView.rangeMax = 10.0
       
        
        
        
        referenceLines.referenceLineUnits = "P"
        referenceLines.includeMinMax = true
        referenceLines.shouldAddLabelsToIntermediateReferenceLines = false
        referenceLines.shouldAddUnitsToIntermediateReferenceLineLabels = false
        
        // All other graph customisation is done in Interface Builder,
        // e.g, the background colour would be set in interface builder rather than in code.
        //graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: dotPlot)
        graphView.addPlot(plot: dotPlot2)
       
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        if(Auth.auth().currentUser != nil){
            do{
                try Auth.auth().signOut()
            } catch {
                print("error in singout process..")
            }
        }
        
        print("User logged out. Calling start Scene")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let startController = storyBoard.instantiateViewController(withIdentifier: "StartController") as! StartController
        self.present(startController, animated:true, completion:nil)
        
    }
    
    
}


