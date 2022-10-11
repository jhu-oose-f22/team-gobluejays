//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var hopkinsCafeStatus: UILabel!
    @IBOutlet weak var nolansStatus: UILabel!
    @IBOutlet weak var leveringKitchensStatus: UILabel!
    @IBOutlet weak var charMarStatus: UILabel!
    @IBOutlet weak var leveringCafeStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.additionalSafeAreaInsets.top = -5
        
        //get current time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        //NOTE: Need to send in current time parameters
        setHopkinsCafeStatus(day: dayOfWeek, hour: hour, minutes: minutes);
        setNolansStatus(day: dayOfWeek, hour: hour, minutes: minutes);
        setLeveringKitchenStatus(day: dayOfWeek, hour: hour, minutes: minutes);
        setCharMarStatus(day: dayOfWeek, hour: hour, minutes: minutes);
        setLeveringCafeStatus(day: dayOfWeek, hour: hour, minutes: minutes);
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
    
    @IBAction func HopkinsCafeMenu(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://hopkinsdining.nutrislice.com/menu/hopkins-cafe")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func NolansMenu(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://hopkinsdining.nutrislice.com/menu/nolans-on-33rd")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func LeveringKitchenMenu(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://hopkinsdining.nutrislice.com/menu/site-1")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func CharMarMenu(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://hopkinsdining.nutrislice.com/menu/site-2")! as URL, options: [:],completionHandler: nil)
    }
    
    @IBAction func LeveringCafeMenu(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://hopkinsdining.nutrislice.com/menu/levering-cafe/cafe")! as URL, options: [:],completionHandler: nil)
    }
    
    func setHopkinsCafeStatus(day: Int, hour: Int, minutes: Int) {
        if (day >= 2 && day <= 6) { //monday - friday
            if (hour >= 7 && hour < 19) {
                hopkinsCafeStatus.text = "Open"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 6) {
                hopkinsCafeStatus.text = "Opening at 7am"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 20) {
                hopkinsCafeStatus.text = "Closing at 8pm"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 20 && hour < 21 && day != 6){
                hopkinsCafeStatus.text = "Opening at 9pm"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour >= 21 && hour < 23 && day != 6) {
                hopkinsCafeStatus.text = "Open"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 23 && hour < 24 && day != 6) {
                hopkinsCafeStatus.text = "Closing at 12am"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                hopkinsCafeStatus.text = "Closed"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        } else { //saturday - sunday
            if (hour >= 10 && hour < 19) {
                hopkinsCafeStatus.text = "Open"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 9) {
                hopkinsCafeStatus.text = "Opening at 10am"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 20) {
                hopkinsCafeStatus.text = "Closing at 8pm"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 20 && hour < 21 && day != 7){
                hopkinsCafeStatus.text = "Opening at 9pm"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour >= 21 && hour < 23 && day != 7) {
                hopkinsCafeStatus.text = "Open"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 23 && hour < 24 && day != 7) {
                hopkinsCafeStatus.text = "Closing at 12am"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                hopkinsCafeStatus.text = "Closed"
                hopkinsCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        }
    }
    
    func setNolansStatus(day: Int, hour: Int, minutes: Int) {
        if (hour >= 10 && hour < 20) {
            nolansStatus.text = "Open"
            nolansStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
        } else if (hour == 9) {
            nolansStatus.text = "Opening at 10am"
            nolansStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
        } else if (hour < 21) {
            nolansStatus.text = "Closing at 9pm"
            nolansStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
        } else {
            nolansStatus.text = "Closed"
            nolansStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
        }
    }
    
    func setLeveringKitchenStatus(day: Int, hour: Int, minutes: Int) {
        if (day >= 2 && day <= 6) { //monday - friday
            if (hour >= 11 && hour < 13) {
                leveringKitchensStatus.text = "Open"
                leveringKitchensStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 10) {
                leveringKitchensStatus.text = "Opening at 11am"
                leveringKitchensStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 14) {
                leveringKitchensStatus.text = "Closing at 2pm"
                leveringKitchensStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                leveringKitchensStatus.text = "Closed"
                leveringKitchensStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        } else {
            leveringKitchensStatus.text = "Closed"
            leveringKitchensStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
        }
    }
    
    func setCharMarStatus(day: Int, hour: Int, minutes: Int) {
        //These are currently the hours for charMar store in general, the deli and meals-in-a-minute have different hours
        if (day >= 2 && day <= 6){
            if ((hour == 7 && minutes >= 30)) {
                charMarStatus.text = "Open"
                charMarStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 8 && hour < 23) {
                charMarStatus.text = "Open"
                charMarStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 6 && minutes >= 30) {
                charMarStatus.text = "Opening at 7:30am"
                charMarStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 24) {
                charMarStatus.text = "Closing at 12am"
                charMarStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                charMarStatus.text = "Closed"
                charMarStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        } else {
            if (hour >= 8 && hour < 23) {
                charMarStatus.text = "Open"
                charMarStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 7) {
                charMarStatus.text = "Opening at 8:00am"
                charMarStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 24) {
                charMarStatus.text = "Closing at 12am"
                charMarStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                charMarStatus.text = "Closed"
                charMarStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        }
    }
    
    func setLeveringCafeStatus(day: Int, hour: Int, minutes: Int) {
        if (day >= 2 && day <= 5) { //monday - thursday
            if ((hour == 7 && minutes >= 30)) {
                leveringCafeStatus.text = "Open"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 8 && hour < 16) {
                leveringCafeStatus.text = "Open"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 6 && minutes >= 30) {
                leveringCafeStatus.text = "Opening at 7:30am"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 17) {
                leveringCafeStatus.text = "Closing at 5pm"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                leveringCafeStatus.text = "Closed"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        } else if (day == 6) {
            if ((hour == 7 && minutes >= 30)) {
                leveringCafeStatus.text = "Open"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour >= 8 && hour < 15) {
                leveringCafeStatus.text = "Open"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else if (hour == 6 && minutes >= 30) {
                leveringCafeStatus.text = "Opening at 7:30am"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            } else if (hour < 16) {
                leveringCafeStatus.text = "Closing at 4pm"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)
            } else {
                leveringCafeStatus.text = "Closed"
                leveringCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
            }
        } else {
            leveringCafeStatus.text = "Closed"
            leveringCafeStatus.textColor = #colorLiteral(red: 0.8774011731, green: 0.469971776, blue: 0.4901964068, alpha: 1)
        }
    }
}
