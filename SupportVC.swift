//
//  SupportVC.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 9/28/22.
//

import UIKit
import MessageUI

class SupportVC: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var issueInput: UITextView!
    
    // view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        issueInput.delegate = self
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
}
