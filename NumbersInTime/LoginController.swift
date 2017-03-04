//
//  LoginController.swift
//  NumbersInTime
//
//  Created by miro on 26.02.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
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
                
            }
            
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#ff0000")

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
                
                let message = "reset password email sent to: " + self.eMail.text!
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        })
        
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
