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
        
        
        let username = self.eMail.text!
        let password = self.password.text!
        
        Auth.auth().signIn(withEmail: username, password: password, completion: {
            (user, error) in
            
            if error != nil{
                
                
               if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .userDisabled:
                        self.alertDefault(title: "Error", message: "your account is disabled")
                    case .wrongPassword:
                        self.alertPassword(title: "Error", message: "incorrect password")
                    case .invalidEmail:
                        self.alertDefault(title: "Error", message: "your email address is malformed")
                    case .userNotFound:
                        self.alertDefault(title: "Error", message: "no user for this email found")
                    default:
                        self.alertDefault(title: "Error", message: "Login Error: \(error!)")                    }
                }

                return
                
            }
            else {
                
                let user = Auth.auth().currentUser
                
                Game.sharedInstance.userName = user?.email
                Game.sharedInstance.userEmail = user?.email
                Game.sharedInstance.userID = user?.uid
                
                
                self.showGameConfig()
                
            }
            
        })
               
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func showGameConfig() {
        print("User logged in. Calling Game Config Scene")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameConfigController = storyBoard.instantiateViewController(withIdentifier: "GameConfigController") as! GameConfigController
        self.present(gameConfigController, animated:true, completion:nil)
    }

    
    
    func handleResetPassword() {
        
        Auth.auth().sendPasswordReset(withEmail: eMail.text!, completion:{
            
            error in
            
            if error != nil {
                
                
            }
            else
            {
                
                let message = "reset password email sent to: " + self.eMail.text!
                self.alertDefault(title: "Info", message: message)
                
            }
            
        })
        
    }
    
    func changeUserNickname(){
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
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
    
    func alertPassword(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "try again", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "reset my password please..", style: .default, handler: { action in
            self.handleResetPassword()
        }))
        
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

extension String {
    
    func isValidateEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
        
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    var length: Int {
        return characters.count
    }
    
}


