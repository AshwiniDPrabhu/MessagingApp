//
//  RegisterViewController.swift
//  MessagingApp
//
//  Created by Ashwini Prabhu on 4/22/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
    
    }
    
    @IBAction func clickedRegisterBtn(_ sender: Any) {
         guard let email = emailField.text, let password = passwordField.text, let name = username.text else{
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if (error != nil){
                print(error!)
                return
        }
        guard let uid = user?.user.uid else{
            return
        }
                
        //if successfully authenticated user
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpg")
        
        if let profileImg = self.profileImage.image,let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1){
        storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                print(error!)
                return
        }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                if let profileImageUrl = url?.absoluteString {
                    let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                }
            })
        })
    }
})
}
                    
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
            let ref = Database.database().reference(fromURL: "https://messagingapp-34171.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if (err != nil){
                    print(err!)
                    return
                }
                
                print("User successfully saved in database")
                self.performSegue(withIdentifier: "registerToChat", sender: self)
            })
            
        }
}
                       

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
   
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
      
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker{
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled Picker")
        dismiss(animated: true, completion: nil)
    }
    
}


