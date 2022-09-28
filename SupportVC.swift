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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueInput.delegate = self
        // Do view setup here.
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    
}
