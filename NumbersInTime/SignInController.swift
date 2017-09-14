//
//  SignInController.swift
//  NumbersInTime
//
//  Created by miro on 01.05.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    
    @IBAction func signInAction(_ sender: Any) {
        
        
        if((email.text?.isEmpty)! || (password.text?.isEmpty)! || (confirmPassword.text?.isEmpty)! ){
            alertDefault(title: "Error", message: "we need all information please..")
            password.text = ""
            confirmPassword.text = ""
            return
        }
        
        if(!(email.text?.isValidateEmail())!){
            alertDefault(title: "Error", message: "please enter valid eMail..")
            email.text = ""
            password.text = ""
            confirmPassword.text = ""
            
            return
        }
        
        if(!password.text!.isEqualToString(find: confirmPassword.text!)){
            alertDefault(title: "Error", message: "please enter the password and confirm it..")
            password.text = ""
            confirmPassword.text = ""
            return
            
        }
        
        if(password.text!.length < 6){
            alertDefault(title: "Error", message: "password must be at least 6 characters long")
            password.text = ""
            confirmPassword.text = ""
            return
            
        }
        
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {
            
            user,error in
            
            if error != nil {
                
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        self.alertDefault(title: "Error", message: "invalid email")
                    case .emailAlreadyInUse:
                        self.alertDefault(title: "Error", message: "email in use")
                    default:
                        self.alertDefault(title: "Error", message: "Create User Error: \(error!)")                    }
                }
                
                return
                
            }
            else {
                
                print ("neuer User erfolgreich angelegt..")
                
                let user = Auth.auth().currentUser
                
                
                
                let message = "user " + (user?.email)! + " created"
                self.alertDefault(title: "Welcome", message: message)
                
                
                self.showGameConfig()
                
            }
            
        })

    
    
    }
    
    
    func showGameConfig() {
        print("User signed/logged in. Calling Game Config Scene")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let gameConfigController = storyBoard.instantiateViewController(withIdentifier: "GameConfigController") as! GameConfigController
        self.present(gameConfigController, animated:true, completion:nil)        
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Basic alert popup
    func alertDefault(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
