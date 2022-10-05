//
//  ViewController.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/6/22.
//

import UIKit

class ScheduleVC: UIViewController,NewEventDelegate {
    var width = 57.5
    var hour = 53.0
    var eight = 162.0
    var monday = 96.0
    var text: String?
    
    func newEventDetail(name:String, start: Double, end: Double, date: Double) {
        print(start)
        print(end)
        print(date)
        view.addSubview(event(title:name, day: date, start: start, duration: (end-start)))
//        view.addSubview(welcomeLabel(title:name, day: date, start: start, duration: 2))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (text != nil) {
//            print(text)
//            view.addSubview(welcomeLabel(title: text! , day: 0, start: 8, duration: 2))
//        }
//        view.addSubview(welcomeLabel(title:"test", day: 0, start: 8, duration: 2))
//        view.addSubview(welcomeLabel(day: 4, start: 10, duration: 1.5))
//        view.addSubview(welcomeLabel(w: 60, h: 100))
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

