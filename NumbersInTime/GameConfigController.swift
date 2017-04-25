//
//  GameConfigController.swift
//  NumbersInTime
//
//  Created by miro on 22.04.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class GameConfigController: UIViewController {

 
    @IBAction func logut(_ sender: Any) {
       
        do {
            try Game.sharedInstance.logout()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartController") as! StartController
            self.present(startViewController, animated:true, completion:nil)            
            
        } catch  {
            
                let alert = UIAlertController(title: "Error", message: "Logout failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
            
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
