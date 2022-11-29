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
    

    init(id: String, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool,completed:Bool,note:String) {
        self.location = location
        self.note = note
        

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, completed:completed, isAllDay: isAllDay, title: title)
    }
    
 

    override func copy(with zone: NSZone?) -> Any {
        return AllDayEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay,completed: completed, note: note)
    }
}
