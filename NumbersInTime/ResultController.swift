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

class ResultController: UIViewController, ScrollableGraphViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var ratio: UILabel!
    @IBOutlet weak var userDisplayName: UILabel!
    
    @IBOutlet weak var graphSubView: ScrollableGraphView!
    
    
    var gameResult :  [String : AnyObject]  = [:]
    var lastResults : [Bool] = []
    
    let gameHistoryKey = "gamehistory"
    
    lazy var ref: DatabaseReference = Database.database().reference()
    var gamesRef: DatabaseReference!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gamesRef = ref.child(gameHistoryKey)
        
        avatar.layer.borderWidth = 1
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        
        
        if(Auth.auth().currentUser != nil){
            userDisplayName.text = Auth.auth().currentUser?.displayName
        }else {
            userDisplayName.text = "no user logged in"
        }
        
        self.graphSubView.dataSource = self
        self.setupGraph(graphView: self.graphSubView)
    }
    
    
    
    func getUsersLastResults(){
        
        var userId = "noUser"
        
        
        if(Auth.auth().currentUser != nil){
            userId = (Auth.auth().currentUser?.email)!
        }
        
        
        
        gamesRef.queryOrdered(byChild: "playerId").queryEqual(toValue: userId).observe(.value, with: {
            
            snapshot in
            
            self.lastResults = []
            var score = 0
            var count = 0
            var rat: Double = 0.0
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots
                {
                    let resultDiff = snap.childSnapshot(forPath: "resultDiff").value! as! Int
                    
                    if(resultDiff == 0){
                        self.lastResults.append(true)
                        score = score + 10
                        count = count + 1
                    } else {
                        self.lastResults.append(false)
                    }
                    
                }
                
                self.lastResults = self.lastResults.reversed()
                
                if( self.lastResults.count > 0 ){
                    rat = Double(count) / Double(self.lastResults.count)
                }
                self.score.text = "\(score) points"
                self.ratio.text = String.localizedStringWithFormat("%.4f %@", rat, "ratio")
                self.graphSubView.reload()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsersLastResults()
        
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
        if(pointIndex == 0){
            return "last game"
        } else {
            return "\(pointIndex)"
        }
    }
    
    func numberOfPoints() -> Int {
        print("numberOfPoints \(self.lastResults.count)")
        return self.lastResults.count
    }
    
    func setupGraph(graphView: ScrollableGraphView) {
        
        // Setup the first line plot.
        let dotPlot = DotPlot(identifier: "one")
        
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointSize = 6.0
        dotPlot.dataPointFillColor = UIColor.green.withAlphaComponent(0.95)
        
        
        let dotPlot2 = DotPlot(identifier: "two")
        
        dotPlot2.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot2.dataPointSize = 6.0
        dotPlot2.dataPointFillColor = UIColor.red.withAlphaComponent(0.9)
        
        
        
        // Customise the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 6)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.0)
        referenceLines.referenceLineLabelColor = UIColor.red
        referenceLines.dataPointLabelColor = UIColor.red.withAlphaComponent(0.8)
        
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


