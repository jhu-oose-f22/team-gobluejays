//
//  AddCourseVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/13/22.
//

import UIKit

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
        let registeredCourse1: RegisteredCourse = RegisteredCourse(semester: "Fall%202022", courseNumber: "EN553436", section: "01");
        ScheduleVC.registeredCourses.append(registeredCourse1)


        print("sisisiii")
        self.view.showToast(message: "HIIIIIII") ///
        let url = "https://sis.jhu.edu/api/classes?key=IwMTzqj8K5swInud8F5s7cAsxPRHOCtZ&Term=" + (term.text ?? "") + "&CourseNumber=" + (courseNumber.text ?? "") + (section.text ?? "")
        print(url)
        
        var booooks:[CourseDetails] = []
        let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                //create toast saying "could not find course, please try again"
                self.view.showToast(message: "Could not find course, please try again.")
                
            } else{
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data {
                    
                    if let books = try? JSONDecoder().decode([CourseDetails].self, from: data) {
                        //print(books)
                        booooks.append(contentsOf: books)
                        if (self.isDuplicateCourse(courseNumber: "")) {
                            //toast saying "course already added"
                            //break out of this whole thing
                            self.view.showToast(message: "Course already added.")
                        } else {
                            //toast saying "course added!"
                            self.view.showToast(message: "Course added!")
                        }
                        
                    } else {
                        print("Invalid Response")
                    }
                }
            }
            print("did i make it here")
            //completion(booooks, nil)
        }
    }
    
    func isDuplicateCourse(courseNumber: String) -> Bool {
        for course in ScheduleVC.registeredCourses {
            if (course.courseNumber == courseNumber) {
                return true
            }
        }
        return false
    }
    
    //need function for button click that checks if the class is valid. if valid, add to ScheduleVC.registeredCourses array and pop a toast. if invalid, pop a toast
    
        //this function will also grab the values in the textboxes and create a url from that
    
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
