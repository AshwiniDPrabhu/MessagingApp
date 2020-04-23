//
//  LoginViewController.swift
//  MessagingApp
//
//  Created by Ashwini Prabhu on 4/22/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
   
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickedLoginBtn(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "loginToChat", sender: self)
                }
            }
        }
        
    }
    
}
