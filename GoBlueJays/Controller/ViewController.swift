//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    

    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var meeting: UILabel!
    @IBOutlet weak var area: UILabel!

    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var term: UILabel!
    
    var fakeMeetings = [Meeting(DOW: "1", Dates: "1", Times: "1", Location: "1", Building: "1", Room: "1")]
    lazy var fakeSectionDetail = [SectionDetail(Description: "1", Meetings: fakeMeetings)]
    lazy var course = CourseDetails(TermStartDate: "1", SchoolName: "1", Meetings: "1", OfferingName: "1", SectionName: "1", Title: "1", Credits: "1", Level: "1", Areas: "1", Building: "1", Term_JSS: "1", SectionDetails: fakeSectionDetail)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hithere")
        print(course.Title)
        level.text = level.text! + course.Level
        credits.text = credits.text! + course.Credits
        courseNumber.text = course.OfferingName
        name.text = course.Title
        department.text = department.text! + course.SchoolName
        meeting.text = meeting.text! + course.Meetings
        term.text = term.text! + course.Term_JSS
        area.text = area.text! + course.Areas
        details.text =  course.SectionDetails[0].Description
        
        for i in 0...(course.SectionDetails[0].Meetings.count - 1) {
            let lecture = course.SectionDetails[0].Meetings[i]
            location.text = location.text! + lecture.Building
            location.text = location.text! + lecture.Room
            if (i != course.SectionDetails[0].Meetings.count - 1 ) {
                location.text = location.text! + ", "
            }
        }
    }


}

