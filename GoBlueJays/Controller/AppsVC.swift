//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class AppsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Transloc(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/transloc/id1280444930")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func MobileOrder(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/transact-mobile-ordering/id1494719529")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func CampusGroups(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://canvas.jhu.edu")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func SIS(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://sis.jhu.edu/sswf/")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func Semesterly(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://jhu.semester.ly")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func MyChart(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://jhu.campusgroups.com/login_only?redirect=https%3a%2f%2fjhu.campusgroups.com%2fgroups")! as URL, options: [:],completionHandler: nil)
    }
    @IBAction func about(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://gobluejays.netlify.app")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func support(_ sender: Any) {
        //UIApplication.shared.open(URL(string: "https://gobluejays.netlify.app/contact")! as URL, options: [:],completionHandler: nil)
    }
    
}

