//
//  ResultController+handler.swift
//  NumbersInTime
//
//  Created by miro on 16.12.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

extension ResultController {
    
    @objc func handleSelectProfileImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        avatar.image = selectedImage
        
        if  let userId = Auth.auth().currentUser?.uid {
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(userId).png")
            
            if let uploadData = UIImagePNGRepresentation(self.avatar.image!) {
                
                storageRef.putData(uploadData, metadata: nil, completion: {
                    
                    (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL() {
                        let user = Auth.auth().currentUser
                        let changeRequest : UserProfileChangeRequest = (user?.createProfileChangeRequest())!
                        changeRequest.photoURL = profileImageUrl
                        
                        changeRequest.commitChanges(completion: {
                            
                            error in
                            
                            if let error = error {
                                self.alertDefault(title: "Error", message: "\(error)")
                            }
                            
                        } )
                        
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Basic alert popup
    func alertDefault(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
