////
////  EventDetailVC.swift
////  GoBlueJays
////
////  Created by Kaia Gao on 11/8/22.
////
//
//import Foundation
//import UIKit
//import FirebaseCore
//import FirebaseFirestore
//import EventKitUI
//import EventKit
//
//
//class EventDetailVC_old: UIViewController {
//    let db = Firestore.firestore()
//    //lazy var eventstore: EKEventStore = EKEventStore()
//    lazy var event = Course()
//
// 
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var startDate: UILabel!
//    @IBOutlet weak var endDate: UILabel!
//    @IBOutlet weak var detail: UILabel!
//    @IBOutlet weak var location: UILabel!
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        name.text = event.name
//        location.text = event.location
//        startDate.text = timeFormat(date: event.date , time: event.startTime)
//        endDate.text = timeFormat(date: event.date , time: event.startTime + event.duration)
//        
//        detail.text = event.notes
//        
//    }
//    
//    func timeFormat(date:String, time:Double)->String{
//        let startHour:Int = Int(time)
//        let startMin:Int = Int((time-Double(startHour))*60)
//        return event.date + "--" + String(startHour) + ":" + String(startMin)
//    }
//    
//    @IBAction func deleteEvent(_ sender: UIButton) {
//        let curEvent = db.collection("scheduleEvents").document(event.uuid)
//        curEvent.delete { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//        
//        _ = navigationController?.popViewController(animated: true)
//        
//    }
//
//    @IBAction func editEvent(_ sender: UIButton) {
//        print("edit")
////        ScheduleVC.showEventViewController()
//        _ = navigationController?.popViewController(animated: true)
//        
//    }
//    
//    @IBAction func markComplete(_ sender: UIButton) {
//        let curEvent = db.collection("scheduleEvents").document(event.uuid)
//        curEvent.updateData(["completed":!event.completed]){
//            err in
//                if let err = err {
//                    print("Error updating document: \(err)")
//                } else {
//                    print("Document successfully updated")
//                }
//        }
//        _ = navigationController?.popViewController(animated: true)
//    }
//    
////    @IBAction func back(_ sender: UIButton) {
////        self.dismiss(animated: true)
////    }
//}
