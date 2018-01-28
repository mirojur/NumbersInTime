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
    
    
    var gameResult :  GameObject? = nil
    var lastResults : [Bool] = []
    
    let gameHistoryKey = "gamehistory"
    
    lazy var ref: DatabaseReference = Database.database().reference()
    var gamesRef: DatabaseReference!
    var scoreRef: DatabaseReference!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        print("viewDidLoad")
        
        super.viewDidLoad()
        
        gamesRef = ref.child(gameHistoryKey)
        scoreRef = ref.child("score")
        
        avatar.layer.borderWidth = 1
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        
        
        if(Auth.auth().currentUser != nil){
            userDisplayName.text = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email
            
            if(( Auth.auth().currentUser?.photoURL ) != nil){
                let data = try? Data(contentsOf: (Auth.auth().currentUser?.photoURL)!)
                
                if (( data ) != nil) {
                    avatar.image = UIImage(data: data!)
                }else {
                    avatar.image = UIImage(named: "avatar")
                }
            }
        }else {
            userDisplayName.text = "no user logged in"
        }
        
        createGraph()
    }
    
    private func createGraph(){
        //self.graphSubView =  Scroll0ableGraphView(frame: self.graphSubView.frame, dataSource: self)
        self.setupGraph(graphView: self.graphSubView)
        self.graphSubView.dataSource = self
        self.getUsersLastResults()
    }
    
    
    
    func getUsersLastResults(){
        
        var userId = "noUser"
        
        
        if(Auth.auth().currentUser != nil){
            userId = (Auth.auth().currentUser?.uid)!
        }
        
        
        //get score data
        ref.child("score/"+userId).observeSingleEvent(of: .value, with: {
            
            (snapshot) in
            
            if( snapshot.exists() ) {
                
                let points = snapshot.childSnapshot(forPath: "points").value! as! Int
                self.score.text = "\(points) points"
                
            }
            
            
        })
        
        
        gamesRef.queryOrdered(byChild: "playerId").queryEqual(toValue: userId).observe(.value, with: {
            
            snapshot in
            
            var newlastResults : [Bool] = []
            var count = 0
            var ratioString = ""
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots
                {
                    let resultDiff = snap.childSnapshot(forPath: "resultDiff").value! as! Int
                    
                    if(resultDiff == 0){
                        newlastResults.append(true)
                        count = count + 1
                    } else {
                        newlastResults.append(false)
                    }
                    
                }
                
                self.lastResults = newlastResults.reversed()
                
                if(self.lastResults.count>0){
                    let ratio: Double = 100*Double(count)/Double(self.lastResults.count)
                    ratioString = String.localizedStringWithFormat("%.2f %@", ratio, "%")
                }
                self.ratio.text = "\(self.lastResults.count) played, \(count) won -> \(ratioString)"
                //"self.las"String.localizedStringWithFormat("%.2f %@", rat, "ratio")
                self.graphSubView.reload()
            }
            
        })
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        self.getUsersLastResults()
        print("exiting viewWillAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        if( pointIndex >= lastResults.count){
            return -100.00
        }
        
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
        return 5
    }
    
    func setupGraph(graphView: ScrollableGraphView) {
        
        // Setup the first line plot.
        let dotPlot = DotPlot(identifier: "one")
        
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointSize = 12.0
        dotPlot.dataPointFillColor = UIColor.green.withAlphaComponent(0.95)
        
        
        let dotPlot2 = DotPlot(identifier: "two")
        
        dotPlot2.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot2.dataPointSize = 8.0
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
        
        graphView.dataPointSpacing = graphView.frame.width / 4.5
        
        
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
    
    func showPlayInCommunityView() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cvController = storyBoard.instantiateViewController(withIdentifier: "CommunityViewController") as! CommunityViewController
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while (topController.presentedViewController != nil)
            {
                topController = topController.presentedViewController!
            }
            topController.present(cvController, animated: true, completion: nil)
        }
    }
    
    
}


