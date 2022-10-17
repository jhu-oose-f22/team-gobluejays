//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var prof: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var details: UILabel!
    
    @IBAction func locationURL(_ sender: Any) {
        UIApplication.shared.open(URL(string: course.locationURL)! as URL, options: [:],completionHandler: nil)
    }
    var course: Course = Course(name: "1", num: "1", date: "1", weekday: 1, location: "1", prof: "1", startTime: 10.0, duration: 10.0, syllabus: ["1"], locationURL: "1", gradescopeURL: "1", webURL: "1")
    
    @IBAction func courseWeb(_ sender: Any) {
        UIApplication.shared.open(URL(string: course.webURL)! as URL, options: [:],completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        name.text = course.name
        var minute = String(Int(course.startTime.truncatingRemainder(dividingBy: 1)*60))
        if (minute.count == 1) {
            minute = "0" + minute;
        }
        time.text = String(Int(course.startTime/1)) + ":" +
                            minute
        location.text = course.location
        prof.text = course.prof
        num.text = course.num
        print(course.name)
        details.numberOfLines = course.syllabus.count
        var grading = ""
        for item in course.syllabus {
            grading += item + " \n"
        }
        details.text = grading
    }


}

