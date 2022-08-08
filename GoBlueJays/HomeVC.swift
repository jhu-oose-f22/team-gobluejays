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
    @IBAction func Brody(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.google.com/?client=safari")! as URL, options: [:],completionHandler: nil)
    }
    
}

