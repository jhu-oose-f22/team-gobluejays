import Foundation
import JZCalendarWeekView

class DefaultEvent: JZBaseEvent {

    var location: String

    init(id: String, title: String, startDate: Date, endDate: Date, location: String, completed:Bool) {
        self.location = location

        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate, completed: completed,title: title)
    }

    override func copy(with zone: NSZone?) -> Any {
        return DefaultEvent(id: id, title: title, startDate: startDate, endDate: endDate, location: location, completed: completed)
    }
}
