//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ScheduleVC: UIViewController{
    var text: String?
    var currentTerm: String?
    var week = ["1", "2", "3", "2", "3"]
    var courses: [Course] = []
    var registeredCourses: [RegisteredCourse] = []
    var currentWeekCourses:[Book] = []
    
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
    
    func setCurrentWeek(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM dd, yyyy" // OR "dd-MM-yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MM/dd/yyyy"
        
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

        MON.text = week[0].substring(with: 3..<5)
        TUE.text = week[1].substring(with: 3..<5)
        WED.text = week[2].substring(with: 3..<5)
        THU.text = week[3].substring(with: 3..<5)
        FRI.text = week[4].substring(with: 3..<5)
        print(week[0])
        currentTerm = "";
        let currentDate = week[0].substring(with: 0..<5);
        if (currentDate >= "08/29" && currentDate < "12/09") {
            
        }
//        if (week[0].substring(with: 0..<2) > ""
    }
    struct Meeting: Decodable {
        let DOW: String
        let Dates: String
        let Times: String
        let Location: String
        let Building: String
        let Room: String
    }
    
    struct SectionDetail: Decodable {
        let Description: String
        let Meetings: [Meeting]
    }
    
    struct Book: Decodable {
        let TermStartDate: String
        let SchoolName: String
        //"MW 12:00PM - 1:15PM, Th 3:00PM - 3:50PM",
        let Meetings: String
        let OfferingName: String
        let SectionName: String
        let Title: String
        let Credits: String
        let Level: String
        let Areas: String
        let Building: String
        let Term_JSS: String
        let SectionDetails : [SectionDetail]
    }
    
    struct RegisteredCourse {
        let semester: String
        let courseNumber: String
    }

    

    @IBOutlet weak var dateTF: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start DatePicker Code
        dateTF.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.sizeToFit()
        dateTF.inputView = datePicker
        dateTF.text = formatDate(date: Date())
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        //End DatePicker Code
        

        //test
        let db = Firestore.firestore()
        // fake data
        // Course1: EN.601.421(01), Fall 2022
        let registeredCourse1: RegisteredCourse = RegisteredCourse(semester: "Fall%202022", courseNumber: "EN55343601");
        let registeredCourse2: RegisteredCourse = RegisteredCourse(semester: "Fall%202022", courseNumber: "EN60142101");
        registeredCourses.append(registeredCourse1);
        registeredCourses.append(registeredCourse2);
        for registeredCourse in registeredCourses {
            let group = DispatchGroup()
            group.enter()
            getRandomFood(semester: registeredCourse.semester, courseNumber: registeredCourse.courseNumber){ json, error in
                self.currentWeekCourses = json ?? []
                group.leave()
            }
            group.wait()
            print("target1")
            print(self.currentWeekCourses)
            displayCourses(books: self.currentWeekCourses)
        }
        setCurrentWeek(date: Date())
    }
    
    func getRandomFood(semester:String,courseNumber:String, completion: @escaping (_ json: [Book]?, _ error: Error?)->()) {
        var booooks:[Book] = []
        
            let url = "https://sis.jhu.edu/api/classes?key=IwMTzqj8K5swInud8F5s7cAsxPRHOCtZ&Term=" + semester + "&CourseNumber=" + courseNumber;
            let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
                if let error = error {
                    print("error: \(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("statusCode: \(response.statusCode)")
                    }
                    if let data = data {
                        
                        if let books = try? JSONDecoder().decode([Book].self, from: data) {
                            //print(books)
                            booooks.append(contentsOf: books)
                        } else {
                            print("Invalid Response")
                        }
                    }
                }
                completion(booooks, nil)
            }
            task.resume()
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = formatDate(date: datePicker.date)
        setCurrentWeek(date: datePicker.date)
        //dateTF.endEditing(true) //this closes the DatePicker when a new date is selected
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL ▼"
        return formatter.string(from: date)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        dateTF.resignFirstResponder()
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
            let y = (course.startTime - 7.0 + 0.8) * oneHour
            courseButton.setTitle(course.name, for: .normal)
            courseButton.titleLabel?.lineBreakMode = .byWordWrapping
            courseButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
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
    func displayCourses(books: [Book]) {
        for book in books {
            for section in book.SectionDetails {
                for meeting in section.Meetings {
                    print(meeting.DOW)
                    var days = parseDOW(DOW:meeting.DOW)
                    let ss = meeting.Times
                    let startStr = ss.substring(with: 0..<8);
                    let endStr = ss.substring(with: 11..<19);
                    let startTime = parseTime(time: startStr)
                    let endTime = parseTime(time: endStr)
                    for day in days {
                    let courseButton = UIButton(type: .system, primaryAction: UIAction(title: "Button Title", handler: { _ in
                        let controller =
                        self.storyboard?.instantiateViewController(withIdentifier: "ViewEventStoryboard") as! ViewController
                        // controller.course = course
                        self.present(controller,animated: true,completion: nil)
                    }));
                    let oneHour = self.view1.frame.height / 17
                    let y = (startTime - 7.0 + 0.7) * oneHour
                    courseButton.setTitle(book.Title, for: .normal)
                    courseButton.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)
                    courseButton.setTitleColor(.black, for: .normal);
                    courseButton.frame = CGRect(x: 0, y: y, width: self.view1.frame.width, height: oneHour*(endTime - startTime));
                    
                        switch (day)  {
                        case "M":
                            self.view1.addSubview(courseButton)
                        case "T":
                            self.view2.addSubview(courseButton)
                        case "W":
                            self.view3.addSubview(courseButton)
                        case "Th":
                            self.view4.addSubview(courseButton)
                        case "F":
                            self.view5.addSubview(courseButton)
                        default:
                            self.view1.addSubview(courseButton)
                        }
                    }
                }
            }
        }
    }
    
    
    func parseTime (time: String) -> Double{
        let hour = Int(time.substring(with: 0..<2)) ?? 0
        let minutes = Int(time.substring(with: 3..<5)) ?? 0
        var res:Double = Double(hour) + Double(Double(minutes) / 60.0)
        if (time.substring(with: 6..<8) == "PM" && time.substring(with: 0..<2) != "12") {
            res += 12.0;
        }
        return res;
    }
    
    func parseDOW (DOW: String) -> [String] {
        var days: [String] = []
        var i :Int = 0
        while (i < DOW.count) {
            let day = DOW.substring(with: i..<(i+1))
            
            if (i+1 < DOW.count && DOW.substring(with: i..<i+2)=="Th") {
                days.append(DOW.substring(with: i..<i+2))
                i += 1
            } else {
                days.append(day)
            }
            i += 1
        }
        return days
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button tapped!")
    }

    // day 0: Monday
    @IBAction func addEvent(_ sender: Any) {
        let controller =
        storyboard?.instantiateViewController(withIdentifier: "AddEventStoryboard") as! AddEventViewController
        controller.modalPresentationStyle = .fullScreen
//        controller.delegate = self
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

extension ScheduleVC: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
}
