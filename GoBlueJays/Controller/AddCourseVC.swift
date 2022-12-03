//
//  AddCourseVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/13/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class AddCourseVC: UIViewController {
    
    @IBOutlet weak var term: UITextField!
    @IBOutlet weak var courseNumber: UITextField!
    @IBOutlet weak var section: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    //need to implement dropdown for term and section later...
    
    @IBAction func addCourse(_ sender: UIButton) {
        
        
        //This works! the course is added to the array in ScheduleVC, but the views don't immediately update at the moment...
    
        let registeredCourse1: RegisteredCourse = RegisteredCourse(semester: term.text ?? "", courseNumber: courseNumber.text ?? "", section: section.text ?? "", uuid: "");
        //ScheduleVC.registeredCourses.append(registeredCourse1)
        //clear database and push to there here***
        let db = Firestore.firestore()
        let uuid = NSUUID().uuidString
        print("uuid: " + uuid)
        //let loginName = CurrentLoginName.name
        //let loginName = "thomas"
        db.collection("thomas").document("scheduleCourses").collection("courses").document(uuid).setData(["Term": registeredCourse1.semester, "CourseNumber": registeredCourse1.courseNumber, "Section": registeredCourse1.section, "uuid": uuid])
        
        
        self.view.showToast(message: "Course Added!")
        
        /*
        var booooks:[CourseDetails] = []
        let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                print("hi im thomasss")
                //create toast saying "could not find course, please try again"
                self.view.showToast(message: "Could not find course, please try again.")
                
            } else{
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    if (self.isDuplicateCourse(courseNumber: "")) {
                        //break out of this whole thing
                        self.view.showToast(message: "Course already added.")
                    } else {
                        //toast saying "course added!"
                        self.view.showToast(message: "Course added!")
                    }
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
            print("did i make it here")
            //completion(booooks, nil)
        }
         */
    }
    /*
    func isDuplicateCourse(courseNumber: String) -> Bool {
        for course in ScheduleVC.registeredCourses {
            if (course.courseNumber == courseNumber) {
                return true
            }
        }
        return false
    }
    */
}


extension UIView {
    func showToast(message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 18)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLbl.numberOfLines = 0
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / window.frame.width ) * 30
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let adjustHeight = max(labelHeight, textSize.height + 20)
        
        toastLbl.frame = CGRect(x: 20, y: window.frame.height - 150, width: labelWidth + 20, height: adjustHeight)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
        UIView.animate(withDuration: 2.0, animations: {
            toastLbl.alpha = 0
        }) { _ in ( )
            toastLbl.removeFromSuperview()
        }
    }
}
