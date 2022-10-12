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
        UIApplication.shared.open(URL(string: "https://jhu.libcal.com/spaces?lid=1195&gid=2086&c=0")!)
    }
    
    @IBAction func tapMSE(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://jhu.libcal.com/seats?lid=1196")!)
    }
    @IBAction func Transloc(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/transloc/id1280444930")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func MobileOrder(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/transact-mobile-ordering/id1494719529")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func Canvas(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://canvas.jhu.edu")! as URL, options: [:],completionHandler: nil)
    } //https://apps.apple.com/us/app/canvas-student/id480883488 use this link instead
    
    @IBAction func SIS(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://sis.jhu.edu/sswf/")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func Semesterly(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://jhu.semester.ly")! as URL, options: [:],completionHandler: nil)
    }
}

