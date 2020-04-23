//
//  MesagingViewController.swift
//  MessagingApp
//
//  Created by Ashwini Prabhu on 4/22/20.
//  Copyright © 2020 experiment. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessagingViewController: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickedLogout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let logoutError{
            print(logoutError)
        }
    }
}
