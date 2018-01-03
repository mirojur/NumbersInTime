//
//  IntroVideoController.swift
//  NumbersInTime
//
//  Created by miro on 21.11.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import VideoSplashKit

class IntroVideoController: VideoSplashViewController {

    @IBAction func skipIntro(_ sender: Any) {
        showNextController()
    }
    
    @IBAction func dontShowAgain(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("false", forKey: "showIntroVideo")
        showNextController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "test", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            videoFrame = view.frame
            fillMode = .resizeAspectFill
            alwaysRepeat = true
            sound = true
            startTime = 1.0
            duration = 15.0
            alpha = 0.7
            backgroundColor = UIColor.black
            contentURL = url
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNextController(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let startController = storyBoard.instantiateViewController(withIdentifier: "StartController") as! StartController
        self.present(startController, animated:true, completion:nil)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
