//
//  AddEventViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 10/4/22.
//

import UIKit

class AddEventViewController: UIViewController {
    var delegate: NewEventDelegate?
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func addEvent(_ sender: Any) {
        var day = 0.0
        
        switch date.text! {
          case "Tue","TUE":
            day = 1.0
          case "Wed","WED":
            day = 2.0
          case "Thur","THUR":
            day = 3.0
          case "Fri","FRI":
            day = 4.0
          default:
            day = 0.0
        }
        
        if let delegate = delegate {
            delegate.newEventDetail(name: name.text!, start: Double(start.text!)!, end: Double(end.text!)!, date: day)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

protocol NewEventDelegate {
    func newEventDetail(name:String, start: Double, end: Double, date: Double)
}
