import Foundation
import JZCalendarWeekView
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AllDayViewModel {
    init(){
        if #available(iOS 16.0, *) {
            reloadData()
        } else {
            // Fallback on earlier versions
        }
        
     
    }
    let db = Firestore.firestore()
    
    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
    open var events:[AllDayEvent] = []
    
    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events)

    var currentSelectedData: OptionsSelectedData!
    
    var registeredCourses: [RegisteredCourse] = []
    var currentWeekCourses:[CourseDetails] = []
    
    
    
    @available(iOS 16.0, *)
    func reloadData(){
        self.events = []
        
        // schedule page init
        initiateEvents(){
            (events) in
            self.events.append(contentsOf: events)
            self.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events)
            
            // schedule vc in different mode
            if let vc = (((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0]{
                switch vc{
                case is LongPressViewController:
                    let calendarWeekView = (vc as! LongPressViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                case is CustomViewController:
                    let calendarWeekView = (vc as! CustomViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                case is DefaultViewController:
                    let calendarWeekView = (vc as! DefaultViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                default:
                    break
                }

            }
            
        }
        
        // load registered course to view controller
        initCourse(){(events) in
            self.events.append(contentsOf: events)
            self.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events)
            if let vc = (((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] {
                switch vc{
                case is LongPressViewController:
                    let calendarWeekView = (vc as! LongPressViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                case is CustomViewController:
                    let calendarWeekView = (vc as! CustomViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                case is DefaultViewController:
                    let calendarWeekView = (vc as! DefaultViewController).calendarWeekView
                    calendarWeekView?.forceReload(reloadEvents: self.eventsByDate)
                default:
                    break
                }
                
                
            }
        }
    }
    func addEvent(event:AllDayEvent){
        
        events.append(event)
        
        
        db.collection(CurrentLoginName.name).document("scheduleDayEvents").collection("events").document(event.id).setData([
            "id":event.id,
            "title": event.title,
            "startDate": event.startDate,
            "location": event.location,
            "endDate": event.endDate,
            "note":event.note,
            "completed":event.completed,
            "isAllDay":event.isAllDay
        ]) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
    
    public func initiateEvents(completion: @escaping ((_ events:[AllDayEvent]) -> Void)) {
        var myevents:[AllDayEvent] = []

        let collection = db.collection(CurrentLoginName.name).document("scheduleDayEvents").collection("events")
        
        collection.getDocuments() {[self] (querySnapshot, err) in
            if let doc = querySnapshot {
                for document in doc.documents {
                    let data = document.data()
                    let event:AllDayEvent = AllDayEvent(id: data["id"] as! String, title: data["title"] as! String, startDate: (data["startDate"] as! Timestamp).dateValue(), endDate: (data["endDate"] as! Timestamp).dateValue(), location: data["location"] as! String, isAllDay: data["isAllDay"] as! Bool, completed: data["completed"] as! Bool, note: data["note"] as! String,type:0, department: [])
                    myevents.append(event)
                    
                }
                completion(myevents)
                
                
            } else{
                    if let err = err {
                    print("Error getting events: \(err)")
                    }
            }
            
        }
        
        
        completion([])
    
    }
    
   
    
}


extension AllDayViewModel{
    
    public func initCourse(completion: @escaping ((_ events:[AllDayEvent]) -> Void)){
        var registeredCourses:[RegisteredCourse] = []
        var myCourses:[AllDayEvent] = []
        let user = CurrentLoginName.name
        let courseCollection = db.collection(user).document("scheduleCourses").collection("courses")
        
        // retrieve data from database on scheduleCourses
        courseCollection.getDocuments() {[self] (querySnapshot, err) in
            if let doc = querySnapshot {
                for document in doc.documents {
                    let data = document.data()
                    let sem = document.data()["Term"] as? String
                    let cn = document.data()["CourseNumber"] as? String
                    let s = document.data()["Section"] as? String
                    let uuid = document.data()["uuid"] as? String
                    
                    // save in RegisteredCourse object
                    let course:RegisteredCourse = RegisteredCourse(semester: sem!, courseNumber: cn!, section: s!, uuid: uuid!)
                    registeredCourses.append(course)
                    
                    // handle ascyn function
                    let group = DispatchGroup()
                    group.enter()
                    getCourses(course:course)
                    { json, error in
                        myCourses.append(contentsOf: json ?? [])
                        group.leave()
                                        }
                    group.wait()

                }
                
                completion(myCourses)


            } else{
                    if let err = err {
                    print("Error getting courses: \(err)")
                    }
            }

            completion([])

        }
    }
    
    
    // get course detail from api
    func getCourses(course:RegisteredCourse, completion: @escaping (_ json: [AllDayEvent]?, _ error: Error?)->()) {
        var courses:[AllDayEvent] = []
        let semester:String = course.semester
        let courseNumber:String = course.courseNumber
        let section:String = course.section
        
            // sis api call to extract course detailed info
            let url = "https://sis.jhu.edu/api/classes?key=IwMTzqj8K5swInud8F5s7cAsxPRHOCtZ&Term=\(semester)&CourseNumber=\(courseNumber)\(section)"
            let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
                
                // connection error
                if let error = error {
                    print("error connecting to SIS\(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("statusCode: \(response.statusCode)")
                    }
                    
                    // data retrieved success
                    if let data = data {

                        if let books = try? JSONDecoder().decode([CourseDetails].self, from: data) {
                            for detail in books{
                                let formatter:DateFormatter = {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "MM-dd-yyyy hh:mm a"
                                    formatter.amSymbol = "AM"
                                    formatter.pmSymbol = "PM"
                                    //"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                    return formatter
                                }()
                                
                                // parse raw data
                                let period:String = detail.SectionDetails[0].Meetings[0].Dates
                                let periodStart = period.components(separatedBy: " to ")[0]
                                let periodEnd = period.components(separatedBy: " to ")[1]
                                let timeStart = detail.SectionDetails[0].Meetings[0].Times.components(separatedBy: " - ")[0]
                                let timeEnd = detail.SectionDetails[0].Meetings[0].Times.components(separatedBy: " - ")[1]
                                
                                // parse date
                                var startDate:Date = formatter.date(from:"\(periodStart) \(timeStart)") ?? Date()
                                var startEndDate:Date = formatter.date(from: "\(periodStart) \(timeEnd)") ?? Date()
                                let endDate: Date = formatter.date(from: "\(periodEnd) \(timeEnd)") ?? Date()
                                
                                let myCourse:AllDayEvent = AllDayEvent(id: course.uuid, title: "\(detail.OfferingName):\(detail.Title)", startDate: startDate, endDate: startEndDate, location: "\(detail.SectionDetails[0].Meetings[0].Location)  \(detail.SectionDetails[0].Meetings[0].Building)  \(detail.SectionDetails[0].Meetings[0].Room)", isAllDay: false, completed: false, note: "", type: 1, department: [])
                                courses.append(myCourse)
                                // date format: "Jun 30, 2020 at 12:00 PM"
                                var date = startDate
                                let weekdays = self.parseDOW(DOW: detail.SectionDetails[0].Meetings[0].DOW)
                                
                                // get all courses within selected range
                                repeat {
                                    for weekday in weekdays {
                                        startDate = Calendar.current.nextDate(after: startDate, matching: DateComponents(hour:startDate.hour(),minute: startDate.minute(),weekday:weekday), matchingPolicy: .previousTimePreservingSmallerComponents)!
                                        startEndDate = Calendar.current.nextDate(after: startEndDate, matching: DateComponents(hour:startEndDate.hour(),minute: startEndDate.minute(),weekday:weekday), matchingPolicy: .previousTimePreservingSmallerComponents)!
                                        print(startDate.description(with: .current), startDate.monthSymbol())
                                        
                                        // store retrieved course data in AllDayEvent object
                                        let mycourse:AllDayEvent = AllDayEvent(id: course.uuid, title: "\(detail.OfferingName):\(detail.Title)", startDate: startDate, endDate: startEndDate, location: "\(detail.SectionDetails[0].Meetings[0].Location)  \(detail.SectionDetails[0].Meetings[0].Building)  \(detail.SectionDetails[0].Meetings[0].Room)", isAllDay: false, completed: false, note: "", type: 1, department: ["\(detail.Term_JSS)","\(detail.SectionName)","\(detail.OfferingName)"])
                                        courses.append(mycourse)
                                        
                                    }
                                } while startDate <= endDate
                                
                            }
                            
                        } else {
                            print("Invalid Response")
                        }
                    }
                }
                completion(courses, nil)
            }
            task.resume()
    }

    // parse weekday from number representation
    func parseDOW(DOW:String)->[Int]{
        var weekdays:[Int] = []
        for i in DOW{
            switch i{
            case "M":
                weekdays.append(2)
            case "T":
                weekdays.append(3)
            case "W":
                weekdays.append(4)
            case "F":
                weekdays.append(6)
            default:
                weekdays.append(5)
                
            }
        }
        return weekdays
    }
}

// date struct to handle time operation
public extension Date {
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    func hour(using calendar: Calendar = .current) -> Int {
        calendar.component(.hour, from: self)
    }
    func minute(using calendar: Calendar = .current) -> Int {
        calendar.component(.minute, from: self)
    }
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
}
