//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ScheduleVC: UIViewController,NewEventDelegate {
    var width = 57.5
    var hour = 53.0
    var eight = 162.0
    var monday = 96.0
    var text: String?
    var week = ["1", "2", "3", "2", "3"]
    var courses: [Course] = []
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var MON: UILabel!
    @IBOutlet weak var TUE: UILabel!
    @IBOutlet weak var WED: UILabel!
    @IBOutlet weak var THU: UILabel!
    @IBOutlet weak var FRI: UILabel!
    @IBOutlet weak var term: UIButton!
    func newEventDetail(name:String, start: Double, end: Double, date: Double) {
        print(start)
        print(end)
        print(date)
        view.addSubview(event(title:name, day: date, start: start, duration: (end-start)))
//        view.addSubview(welcomeLabel(title:name, day: date, start: start, duration: 2))
    }
    
    func setCurrentWeek() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM dd, yyyy" // OR "dd-MM-yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        
        let month = dateFormatter2.string(from: date).substring(with: 3..<5)
        var monthString = "";
        switch (month)  {
          case "01","1":
            monthString = "January"
          case "02","2":
            monthString = "February"
          case "03","3":
            monthString = "January"
          case "04","4":
            monthString = "February"
          case "05","5":
            monthString = "January"
          case "06","6":
            monthString = "February"
          case "07","7":
            monthString = "January"
          case "08","8":
            monthString = "February"
          case "09","9":
            monthString = "September"
          case "10":
            monthString = "October"
          case "11":
            monthString = "November"
          case "12":
            monthString = "December"
          default:
            monthString = "default"
        }
        term.setTitle(monthString, for: .normal)
        
        var mondayIndex = 0;
        let currentDateString: String = dateFormatter.string(from: date)
        let currentWeekday = currentDateString.prefix(3);
        switch (currentWeekday)  {
          case "Mon":
            mondayIndex = 0;
          case "Tue":
            mondayIndex = -1;
          case "Wed":
            mondayIndex = -2;
          case "Thu":
            mondayIndex = -3;
          case "Fri":
            mondayIndex = -4;
          case "Sat":
            mondayIndex = 2;
          case "Sun":
            mondayIndex = 1;
          default:
            mondayIndex = 0;
        }
        for i in 0...4 {
            let dateNext = Calendar.current.date(byAdding: .day, value: (mondayIndex + i), to:date)!
            week[i] = dateFormatter2.string(from: dateNext)
        }

        MON.text = week[0].substring(with: 0..<2)
        TUE.text = week[1].substring(with: 0..<2)
        WED.text = week[2].substring(with: 0..<2)
        THU.text = week[3].substring(with: 0..<2)
        FRI.text = week[4].substring(with: 0..<2)
        print(week[0])
    }
    
    
    @IBOutlet weak var dateTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .inline
        dateTF.inputView = datePicker
        dateTF.text = formatDate(date: Date())
        
//        let a;
        //test
        let db = Firestore.firestore()
        setCurrentWeek()
        
        db.collection("calendarCourse").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    guard let dateee = data["date"] as? String else {
                        return
                    }
//                    print(dateee)
                    if let fooOffset = self.week.firstIndex(where: {$0 == dateee}) {
                        print("found date in current week: \(dateee)")
                        print(fooOffset)
                        
                        let course1: Course = Course(name: data["courseName"] as! String, num: data["courseNum"] as! String , date: data["date"] as! String , weekday: fooOffset , location: data["location"] as! String, prof: data["prof"] as! String, startTime: data["startTime"] as! Double, duration: data["duration"] as! Double, syllabus: data["syllabus"] as! [String], locationURL: data["locationURL"] as! String, gradescopeURL: data["gradescopeURL"] as! String, webURL: data["webURL"] as! String)
                        self.courses.append(course1)
                    } else {
                        print("nono")
                    }
                }
                showCourses(courses: courses)
                
                
//                self.view.addSubview(event(title:self.courses[0].name, day: self.courses[0].weekday, start: self.courses[0].startTime, duration: self.courses[0].duration))
            }
        }
        
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: date)
    }
    
    func showCourses(courses: [Course]) {
        for course in courses {
            let courseButton = UIButton(type: .system, primaryAction: UIAction(title: "Button Title", handler: { _ in
                let controller =
                self.storyboard?.instantiateViewController(withIdentifier: "ViewEventStoryboard") as! ViewController
                controller.course = course
                self.present(controller,animated: true,completion: nil)
            }));
            let oneHour = self.view1.frame.height / 17
            let y = (course.startTime - 7.0 + 0.6) * oneHour
            courseButton.setTitle(course.name, for: .normal)
            courseButton.backgroundColor = .blue
            courseButton.setTitleColor(.black, for: .normal);
            courseButton.frame = CGRect(x: 0, y: y, width: self.view1.frame.width, height: oneHour*course.duration);
            switch (course.weekday)  {
              case 0:
                self.view1.addSubview(courseButton)
              case 1:
                self.view2.addSubview(courseButton)
              case 2:
                self.view3.addSubview(courseButton)
              case 3:
                self.view4.addSubview(courseButton)
              case 4:
                self.view5.addSubview(courseButton)
              default:
                self.view1.addSubview(courseButton)
            }
            
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
            print("Button tapped!")
        }

    // day 0: Monday
    func event (title: String, day: Double, start: Double, duration: Double) -> UIView {
        let x = monday + day * width
        let y = eight + (start - 8.0) * hour
        let h = duration * hour
        
        let myNewView=UIView(frame: CGRect(x: x, y: y, width: width, height: h))
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = " " + title
        label.textColor = .white
        label.frame = CGRect(x: 0, y: 0, width: width, height: 20)
        
        myNewView.addSubview(label)
        myNewView.backgroundColor=UIColor(red: 0, green: 0.6353, blue: 0.9765, alpha: 1.0)
        myNewView.layer.cornerRadius = 5
        return myNewView
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let controller =
        storyboard?.instantiateViewController(withIdentifier: "AddEventStoryboard") as! AddEventViewController
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        present(controller,animated: true,completion: nil)
    }

}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
