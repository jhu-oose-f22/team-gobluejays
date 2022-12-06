//
//  LoginViewController.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 12/6/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class LoginViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var loginName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let loginName = loginName.text!
        if (loginName != "") {
            db.collection(loginName).document("Profile").setData(["Login": "Yes"])
            CurrentLoginName.name = loginName
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! CustomTabBarController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
    }
}
