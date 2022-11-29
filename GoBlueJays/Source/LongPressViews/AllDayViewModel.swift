//
//  AllDayViewModel.swift
//  JZCalendarWeekViewExample
//
//  Created by Jeff Zhang on 30/5/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import Foundation
import JZCalendarWeekView
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AllDayViewModel {
    init(){
//        self.addEvent(event: defaultEvent) //add Default to initialize DB
        reloadData()
     
    }
    let db = Firestore.firestore()
    
    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
//    let defaultEvent = AllDayEvent(id: "0", title: "One", startDate: Date(), endDate: Date(), location: "Melbourne", isAllDay: false,completed: false)
    
    open var events:[AllDayEvent] = []
    
    
    
    func reloadData(){
        initiateEvents(){
            (events) in
            self.events = events
            self.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)
            if let vc = ((UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] {
//                print("reloading")
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
        db.collection("scheduleEvents").document(event.id).setData([
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
            } else {
                print("Document added with ID:\(event.id)")
            }
        }
    }
    
    public func initiateEvents(completion: @escaping ((_ events:[AllDayEvent]) -> Void)) {
        var myevents:[AllDayEvent] = []
        var collection = db.collection("scheduleEvents")
        collection.getDocuments() {[self] (querySnapshot, err) in
            if let doc = querySnapshot {
                for document in doc.documents {
                    let data = document.data()
                    let event:AllDayEvent = AllDayEvent(id: data["id"] as! String, title: data["title"] as! String, startDate: (data["startDate"] as! Timestamp).dateValue(), endDate: (data["endDate"] as! Timestamp).dateValue(), location: data["location"] as! String, isAllDay: data["isAllDay"] as! Bool, completed: data["completed"] as! Bool, note: data["note"] as! String)
                    myevents.append(event)
                    
                }
                completion(myevents)
                
                
            } else{
                    if let err = err {
                    print("Error getting documents: \(err)")
                    }
            }
            

            
        }
        
        completion([])
        
//        self.events = myevents

//        return myevents
    }
    
    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: self.events)

    var currentSelectedData: OptionsSelectedData!
}
