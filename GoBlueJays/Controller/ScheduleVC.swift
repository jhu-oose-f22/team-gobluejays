//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

import SwiftUI
import EventKitUI


class ScheduleVC: UIViewController{
    var text: String?
    var currentTerm: String?
    var week = ["1", "2", "3", "2", "3"]
    var courses: [Course] = []
    static var registeredCourses: [RegisteredCourse] = []
    var currentWeekCourses:[CourseDetails] = []
    let db = Firestore.firestore()
    var curCourse:Course = Course()
    
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
        
//        let month = dateFormatter2.string(from: date).substring(with: 3..<5)
//        var monthString = "";
//        switch (month)  {
//          case "01","1":
//            monthString = "January"
//          case "02","2":
//            monthString = "February"
//          case "03","3":
//            monthString = "January"
//          case "04","4":
//            monthString = "February"
//          case "05","5":
//            monthString = "January"
//          case "06","6":
//            monthString = "February"
//          case "07","7":
//            monthString = "January"
//          case "08","8":
//            monthString = "February"
//          case "09","9":
//            monthString = "September"
//          case "10":
//            monthString = "October"
//          case "11":
//            monthString = "November"
//          case "12":
//            monthString = "December"
//          default:
//            monthString = "default"
//        }
        
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
        print("print from set")
        print(week[0])
        currentTerm = "";
        let currentDate = week[0].substring(with: 0..<5);
//        if (currentDate >= "08/29" && currentDate < "12/09") {
//
//        }
//       if (week[0].substring(with: 0..<2) > ""
    }

    @IBOutlet weak var dateTF: TextField!
//
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCourseEvent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentWeek(date: Date())
        
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
//        let db = Firestore.firestore()
        // fake data
        // Course1: EN.601.421(01), Fall 2022
        //let registeredCourse1: RegisteredCourse = RegisteredCourse(semester: "Fall%202022", courseNumber: "EN536", section: "01");
        let registeredCourse2: RegisteredCourse = RegisteredCourse(semester: "Fall%202022", courseNumber: "EN601421", section: "01");
        //ScheduleVC.registeredCourses.append(registeredCourse1);
        ScheduleVC.registeredCourses.append(registeredCourse2);
        reloadCourseEvent()
        
    }
    
    func getCourses(semester:String,courseNumber:String,section:String, completion: @escaping (_ json: [CourseDetails]?, _ error: Error?)->()) {
        var booooks:[CourseDetails] = []
        
            let url = "https://sis.jhu.edu/api/classes?key=IwMTzqj8K5swInud8F5s7cAsxPRHOCtZ&Term=" + semester + "&CourseNumber=" + courseNumber + section;
            let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
                if let error = error {
                    print("hi im thomas")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("statusCode: \(response.statusCode)")
                    }
                    if let data = data {
                        
                        if let books = try? JSONDecoder().decode([CourseDetails].self, from: data) {
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
        
        reloadCourseEvent()
            
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EventDetailVC
        destinationVC.event = curCourse
    
    }
    
    
    func showCourses(courses: [Course]) {
        
        for course in courses {
            curCourse = course
//            let courseButton = UIButton(type: .system, primaryAction: UIAction(title: "Button Title", handler: { _ in
////                let controller =
////                self.storyboard?.instantiateViewController(withIdentifier: "ViewEventStoryboard") as! ViewController
////                controller.course = book
////                self.present(controller,animated: true,completion: nil)
//
//                var textField = UITextField() // refer to the locol variable of text field
//
//                 // Pop up an alert
//                let alert = UIAlertController(title: course.name, message: "", preferredStyle: .alert) // .alert == UIAlertController.alert
//
//                 // Add a button and Apply the default style to the action button when the user taps a button in an alert.
//
//                alert.addAction(UIAlertAction(title: NSLocalizedString("Completed！", comment: "Default action"), style: .default, handler: { _ in
//                    course.completed = !course.completed
//                }))
//
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                  print("Handle Cancel Logic here")
//                  }))
//                 // add a textfield
//                 alert.addTextField{
//                     // Trigger the closure only when the text field is added to the alert
//                     (alertTextField) in alertTextField.placeholder = "Create a new item"
//                     // ! Extend the scope of alertTextField to the whole function
//                     textField = alertTextField // textField has a scope of entile addButtonPressed function while the alertTextField only has it inside the closure
//
//                     // print(alertTextField.text) // empty!!!
//                 }
//
//                 // attach the action object to the alert
//                //  Add your label
//                      let margin:CGFloat = 8.0
//                      let rect = CGRect(x: margin, y: 72.0, width: alert.view.frame.width - margin * 2.0 , height: 20)
//                      let label = UILabel(frame: rect)
//                      label.text = "withLabel"
//                      label.textAlignment = .center
//                      label.adjustsFontSizeToFitWidth = true
//                      label.minimumScaleFactor = 0.5
//                      alert.view.addSubview(label)
//
//                 // present the alert view controller
//                self.present(alert, animated: true, completion: nil)
//            }))
            
            let courseButton = UIButton(type: .system, primaryAction: UIAction(title: "show event", handler: { _ in
                let controller =
                self.storyboard?.instantiateViewController(withIdentifier: "EventDetailStoryboard") as! EventDetailVC
                
                controller.event = course
//                self.present(controller,animated: true,completion: nil)
                self.performSegue(withIdentifier: "showEventDetail", sender: self)
                
            }))
                                                                               
            let oneHour = self.view1.frame.height / 17
            let y = (course.startTime - 7.0 + 0.85) * oneHour
            courseButton.setTitle(course.name, for: .normal)
            courseButton.titleLabel?.font = UIFont(name: "GillSans-Italic", size: 10)
            courseButton.titleLabel?.lineBreakMode = .byWordWrapping
            if !course.completed{
                courseButton.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)}
            else{
                courseButton.backgroundColor = UIColor(red: 0/255, green: 255/255, blue: 50/255, alpha: 0.5)
            }
            courseButton.setTitleColor(.black, for: .normal);

            courseButton.frame = CGRect(x: 0, y: y, width: self.view1.frame.width, height: oneHour*course.duration);
//            let label = UILabel(frame: CGRect(x: 100, y: 100, width: self.view1.frame.width, height: 21))
//            label.text = "I'm a test label"
//            courseButton.addSubview(label)
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
    
    struct Color {
        let red: Int
        let green: Int
        let blue: Int
    }
    
    var Colors = [Color(red: 255, green: 229, blue: 204),Color(red: 204, green: 204, blue: 255),Color(red: 255, green: 255, blue: 204),Color(red: 229, green: 204, blue: 255)]
    var index = 0;
    func displayCourses(books: [CourseDetails]) {
        for book in books {
            var color = Colors[index % Colors.count]
            index = index + 1
            print(index)
            for section in book.SectionDetails {
                for meeting in section.Meetings {
                    print(meeting.DOW)
                    var days = parseDOW(DOW:meeting.DOW)
                    let ss = meeting.Times
                    let startStr = ss.substring(with: 0..<8)
                    let endStr = ss.substring(with: 11..<19)
                    let startTime = parseTime(time: startStr)
                    let endTime = parseTime(time: endStr)
                    let semesterDates = meeting.Dates
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let courseStart = dateFormatter.date(from: semesterDates.substring(with: 0..<2) + "/" + semesterDates.substring(with: 3..<5) + "/" + semesterDates.substring(with: 6..<10))
                    
                    let courseEnd = dateFormatter.date(from: semesterDates.substring(with: 14..<16) + "/" + semesterDates.substring(with: 17..<19) + "/" + semesterDates.substring(with: 20..<24))
                    let current = dateFormatter.date(from: week[2])
                    print(week[2])
                    print("selected week, tuesday")

                    if (courseStart! <= current! && current! <= courseEnd!) {
                        
                        for day in days {
                            let courseButton = UIButton(type: .system, primaryAction: UIAction(title: "Button Title", handler: { _ in
                                let controller =
                                self.storyboard?.instantiateViewController(withIdentifier: "ViewEventStoryboard") as! ViewController
                                controller.course = book
                                self.present(controller,animated: true,completion: nil)
                            }));
                            let oneHour = self.view1.frame.height / 16.5
                            let y = (startTime - 7.0 + 0.85) * oneHour
                            courseButton.setTitle(book.Title, for: .normal)
                            courseButton.titleLabel?.font = UIFont(name: "GillSans", size: 9)
                            courseButton.titleLabel?.lineBreakMode = .byWordWrapping
                            print("red")
                            print(color.red)
                            print(CGFloat(color.red/255))
                            print(color.green)
                            courseButton.backgroundColor = UIColor(red: CGFloat(color.red/255), green: CGFloat(color.green/255), blue: CGFloat(color.blue/255), alpha: 0.2)
                            courseButton.setTitleColor(.black, for: .normal);
                            courseButton.frame = CGRect(x: 0, y: y, width: self.view1.frame.width, height: oneHour*(endTime - startTime));
                            switch (day) {
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
                                self.view2.addSubview(courseButton)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isBetween(start: Date, end: Date, event: Date ) -> Bool {
        if (start <= event && event <= end) {
            return true
        }
        return false
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
//    @IBAction func addEvent(_ sender: Any) {
//        let controller =
//        storyboard?.instantiateViewController(withIdentifier: "AddEventStoryboard") as! AddEventViewController
//        controller.modalPresentationStyle = .fullScreen
////        controller.delegate = self
//        present(controller,animated: true,completion: nil)
//    }

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
        textField.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
}


extension ScheduleVC: EKEventEditViewDelegate {
    @IBAction func addEvent(_ sender: UIButton) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
                if granted {
                    // do stuff
                    DispatchQueue.main.async {
                        self.showEventViewController()
                    }
                }
            }
        case .authorized:
            // do stuff
            DispatchQueue.main.async {
                self.showEventViewController()
            }
        default:
            break
        }
    }
    
    func showEventViewController(){
        let eventVC = EKEventEditViewController()
        eventVC.delegate = self //?
        eventVC.editViewDelegate = self // The delegate to notify when editing an event.
        eventVC.eventStore = EKEventStore()
        
        
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = "Hello calendar!"
        event.startDate = Date()
        event.notes = ""
        eventVC.event = event
        
        present(eventVC, animated: true)
    }
    
    
    func convertTime(at date: Date) -> Double{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        return (Double(timeFormatter.string(from: date).substring(with: 0..<2)) ?? 7.0) + (Double(timeFormatter.string(from: date).substring(with: 3..<5)) ?? 0.0)/60.0
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        var name: String = controller.event?.title ?? "Empty Title"
        var startDate: Date = controller.event?.startDate ?? Date()
        var endDate: Date = controller.event?.endDate ?? Date()
        var isAllDay: Bool = controller.event?.isAllDay ?? false
        var location: String = controller.event?.location ?? ""
        var notes: String = controller.event?.notes ?? ""
        var alarms:[EKAlarm] = controller.event?.alarms ?? []
        var recurrenceRules:[EKRecurrenceRule] = controller.event?.recurrenceRules ?? []
        var recurrenceInterval:Int
        var recurrenceEndDate: Date
        var recurrenceFreq: Int
        if controller.event?.hasRecurrenceRules == true{
            recurrenceEndDate = recurrenceRules[0].recurrenceEnd?.endDate ?? startDate
//            recurrenceInterval = recurrenceRules[0].interval
            recurrenceFreq = recurrenceRules[0].frequency.rawValue
            print(recurrenceRules) // [EKRecurrenceRule <0x600000bdf8e0> RRULE FREQ=WEEKLY;INTERVAL=1;UNTIL=20221208T034900Z]
            print(recurrenceEndDate) //2022-12-08 04:20:00 +0000
//            print(recurrenceInterval) // 1
            print(recurrenceFreq) // 0 = daily, 1 = weekly, 2 = monthly, 3 = yearly
//            print(alarms[0].relativeOffset) //-600
            
        }
        let dateComponents = DateComponents(year: 2022, month: 2)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("days:\(numDays)")
//        switch(recurrenceFreq){
//        case 0: // daily
//            recurrenceInterval = 1;
//            break;
//        case 1: //weekly
//            recurrenceInterval = 7;
//            break;
//        case 2: //monthly
//            recurrenceInterval = 1;
//            break;
//        case 3: //yearly
//            recurrenceInterval = 1;
//            break;
//
//        default:
//
//        }
        
        
        
        /**
         Convert date to string
         */
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        var couseDate:String = dateFormatter.string(from: startDate)
        /**
         Convert date to Time
         */
        var startTime:Double = convertTime(at: startDate)
        var endTime:Double = convertTime(at: endDate)
        var duration: Double = endTime - startTime
        print(name,startTime,endTime,duration,location,notes,alarms) // New course! 12.0 18.0 6.0 JHU 3400 N Charles Street, Baltimore, MD 21218, United States Balalaika
        
        let uuid = controller.event?.eventIdentifier ?? "0"
        db.collection("scheduleEvents").document(uuid).setData([
            "uuid":uuid,
            "name": name,
            "date": couseDate,
            "location": location,
            "startTime": startTime,
            "duration": duration,
            "notes":notes,
            "completed":false
        ]) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID:\(uuid)")
            }
        }
        
        dismiss(animated: true, completion: nil)
        reloadCourseEvent()
        
        
            
    }
    
    func reloadCourseEvent(){
        for v in [view1,view2, view3,view4,view5] {
            for subview in v!.subviews {
                if (subview is UIButton) {
                    subview.removeFromSuperview()
                }
            }
        }
        for registeredCourse in ScheduleVC.registeredCourses {
                    let group = DispatchGroup()
                    group.enter()
                    getCourses(semester: registeredCourse.semester, courseNumber: registeredCourse.courseNumber, section: registeredCourse.section){ json, error in
                        self.currentWeekCourses = json ?? []
                        group.leave()
                    }
                    group.wait()
                    displayCourses(books: self.currentWeekCourses)
                }
        courses = []
        db.collection("scheduleEvents").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    guard let dateee = data["date"] as? String else {
                        return
                    }
                    if let fooOffset = self.week.firstIndex(where: {$0 == dateee}) {
                        print("found date in current week: \(dateee)")
                        print(fooOffset)
                        
                        let course1: Course = Course(
                            uuid:data["uuid"] as! String,
                            name: data["name"] as! String,
                            date: data["date"] as! String ,
                            weekday: fooOffset,
                            location: data["location"] as! String,
                            startTime: data["startTime"] as! Double,
                            duration: data["duration"] as! Double,
                            notes: data["notes"] as! String,
                            completed: data["completed"] as! Bool)
                        self.courses.append(course1)
                    } else {
                        print("nono")
                    }
                }
                showCourses(courses: courses)
            }
        }
    }
}

extension ScheduleVC:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController.isKind(of: UITableViewController.self)){
            let tblViewVC:UITableViewController = viewController as! UITableViewController
            let tblView = tblViewVC.tableView
            // 0,0: Name
            // 0,1: All-Day
            // 0,2: Repeat
            // 0,4: Elert
            // 0,6: Attachment
            // 0,8: url
            // 1,0: Locatiion
            // 1,1: Starts
            // 1,8: Notes
            // 2,1: Ends
            // 3,1: Travel Time
            
            let keepArr:[String] = ["00","11","21"]
            for i in 0...11{
                for j in 0...11{
                    if !(keepArr.contains("\(i)\(j)")){
                        if let cell:UITableViewCell = (tblView?.cellForRow(at: IndexPath(row: i, section: j))){
                            cell.isUserInteractionEnabled=false
                            cell.isHidden = true
                        }
                    }
                    
                }
            }
//            print("calling")
//            print(tblView?.visibleCells.count)
//            print(tblView?.visibleCells.description)
//            tblView?.deleteSections(IndexSet([1]),with:.automatic)
//            for i in [1,2,4,6,8]{
//                let cell:UITableViewCell = (tblView?.cellForRow(at: IndexPath(row: 0, section: i)))!
////                print(cell.description)
//                cell.isUserInteractionEnabled=false
//                cell.isHidden = true
//            }


            
            



            

        }
        
    }
    

   
    
}
