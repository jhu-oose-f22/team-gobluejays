//
//  AllDayEvent.swift
//  JZCalendarViewExample
//
//  Created by Jeff Zhang on 3/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import JZCalendarWeekView
import Foundation

class AllDayEvent: JZAllDayEvent {

    var location: String
    var note: String
    var type: Int //0: Event, 1: Course
    var department: [ String]
    

    init(id: String, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool,completed:Bool,note:String, type: Int, department: [String]) {
        self.location = location
        self.note = note
        self.type = type
        
        self.department = department

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, completed:completed, isAllDay: isAllDay, title: title)
    }
    
    // make a copy of current object
    override func copy(with zone: NSZone?) -> Any {
        return AllDayEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay,completed: completed, note: note, type: type, department: department)
    }
}
