//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.additionalSafeAreaInsets.top = -5
    }
    @IBAction func tapBrody(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "https://jhu.libcal.com/spaces?lid=1195&gid=2086&c=0")!)
    }
    
    @IBAction func tapMSE(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "https://jhu.libcal.com/seats?lid=1196")!)
    }
    
}

