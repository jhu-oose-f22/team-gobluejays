//
//  EditProfileVC.swift
//  GoBlueJays
//
//  Created by david on 11/3/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var jhedField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var SchoolField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        self.saveText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveText() {
        let nameText = self.nameField.text!
        let jhedText = self.jhedField.text!
        let emailText = self.emailField.text!
        let phoneText = self.phoneField.text!
        let SchoolText = self.SchoolField.text!
        let bioText = self.bioField.text!
        let db = Firestore.firestore()
        let dict = ["Name": nameText,
                    "JHED": jhedText,
                    "Email": emailText,
                    "Phone": phoneText,
                    "School": SchoolText,
                    "Bio": bioText]
        let oldDict = db.collection("Profile")
        db.collection("Profile").addDocument(data: dict)
    }
}
