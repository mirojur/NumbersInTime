//
//  LoginController.swift
//  NumbersInTime
//
//  Created by miro on 26.02.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func signInAction(_ sender: Any) {
        
        
        
        FIRAuth.auth()?.createUser(withEmail: eMail.text!, password: password.text!, completion: {
            
            user,error in
            
            if error != nil {
                
                self.login()
                
            }
            else {
                
                print ("neuer User erfolgreich angelegt..")
                
                let uDefaults = UserDefaults.standard
                
                let user = FIRAuth.auth()?.currentUser
                print("user email:" + (user?.email)!)
                print("user ID:" + (user?.uid)!)
                
                uDefaults.set(user?.email, forKey: "myEMAIL")
                uDefaults.set(user?.uid, forKey: "myID")
                uDefaults.synchronize()
                
                
            }
            
            
        })
        
    }
    
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func login()  {
        
        FIRAuth.auth()?.signIn(withEmail: eMail.text!, password: password.text!, completion: {
            user, error in
            
            if error != nil{
                
                let alert = UIAlertController(title: "", message: "wrong user/password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Reset password", style: .default, handler: {(action) in self.handleResetPassword()}))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                
                print("login erfolgreich")
                
                let user = FIRAuth.auth()?.currentUser
                print("user email:" + (user?.email)!)
                print("user ID:" + (user?.uid)!)
                
                Game.userName = user?.email
                Game.userEmail = user?.email
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let gameConfigController = storyBoard.instantiateViewController(withIdentifier: "GameConfigController") as! GameConfigController
                self.present(gameConfigController, animated:true, completion:nil)
                
                
                                
            }
            
        })
        
    }
    
   
    
    func handleResetPassword() {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: eMail.text!, completion:{
            
            error in
            
            if error != nil {
                
                
            }
            else
            {
                
                _ = "reset password email sent to: " + self.eMail.text!
                
            }
            
        })
        
    }
    
    func changeUserNickname(){
        
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        
        changeRequest?.displayName = nickname.text
        changeRequest?.commitChanges() {
            
            error in
            
            if error != nil {
                
                let message = "unable to change your nickname.please try later!"
                self.alertDefault(title:"Error", message: message)
                
            }
            else
            {
                
                
            }
            
            
        }
        
    }
    
    //Basic alert popup
    func alertDefault(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension UIColor{
    
    convenience init(hex: String){
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )

    }
    
}


