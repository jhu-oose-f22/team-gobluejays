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
    @IBOutlet weak var loginName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //This simply creates the collection if it doesn't exist yet
        
        if (loginName.text != "") {
            db.collection(loginName.text!).document("Profile").setData(["Login": "Yes"])
            CurrentLoginName.name = loginName.text!
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! CustomTabBarController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
        //TODO: Store the loginName so that it can be used elsewhere
    }
    
    
}

struct CurrentLoginName {
    static var name = ""
}
