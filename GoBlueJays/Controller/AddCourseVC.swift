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
        self.hideKeyboardWhenTappedAround()
    
    }
    
    @IBAction func addCourse(_ sender: UIButton) {
    
        let registeredCourse1: RegisteredCourse = RegisteredCourse(semester: term.text ?? "", courseNumber: courseNumber.text ?? "", section: section.text ?? "", uuid: "");
        
        //clear database and push to there here
        let db = Firestore.firestore()
        let uuid = NSUUID().uuidString
        print("uuid: " + uuid)
        let user = CurrentLoginName.name
        db.collection(user).document("scheduleCourses").collection("courses").document(uuid).setData(["Term": registeredCourse1.semester, "CourseNumber": registeredCourse1.courseNumber, "Section": registeredCourse1.section, "uuid": uuid])
        
        
        self.view.showToast(message: "Course Added!")
        
        if #available(iOS 16.0, *) {
            var viewModel =  ((((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).viewModel
            viewModel.reloadData()
        } else {
            // Fallback on earlier versions
        }
    }
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
