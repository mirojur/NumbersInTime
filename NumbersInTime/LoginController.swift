//
//  LoginController.swift
//  NumbersInTime
//
//  Created by miro on 26.02.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftValidator // framework

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
    
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
       
        validator.registerField(eMail,errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule()])
    }
    
    func validationSuccessful() {
        // submit the form
    }
    
    func validationFailed(errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
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
                
                print("hurraaaa, login erfolgreich")
                
                let user = FIRAuth.auth()?.currentUser
                print("user email:" + (user?.email)!)
                print("user ID:" + (user?.uid)!)
                
                
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


