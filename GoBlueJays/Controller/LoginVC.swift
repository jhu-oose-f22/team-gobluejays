//
//  LoginVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/30/22.
//


import FirebaseFirestore
import FirebaseCore
import UIKit

class LoginVC: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var login: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let loginName = login.text!
        if (loginName != "") {
            db.collection(loginName).document("Profile").setData(["Login": "Yes"])
            CurrentLoginName.name = loginName
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! CustomTabBarController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
    }
    
    
}
