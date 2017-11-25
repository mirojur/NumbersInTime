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

class ResultController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
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
    
    var gameResult :  [String : AnyObject]  = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(Auth.auth().currentUser==nil){
           logoutButton.setTitle("Back", for: UIControlState.normal)
        }
        
        
        if(gameResult["gameHistory"] != nil){
        
            let gameHistory:String = gameResult["gameHistory"] as! String
            let gameSeq = gameHistory.components(separatedBy: ";")
            
            // Do any additional setup after loading the view.
            
            let targetNumber: String =  String(gameResult["targerNumber"] as! Int)
            let myResult: String = String(gameResult["result"] as! Int)
            
            textView.text.append("target number: " + targetNumber + "\n")
            textView.text.append("your way:\n")
            
            for index in 0...gameSeq.capacity-1{
                let gameSeqText = gameSeq[index]
                textView.text.append(gameSeqText)
                textView.text.append("\n")
            }
            
            textView.text.append("your result: " + myResult)
            
            
        }else {
            textView.text.append("no data")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


