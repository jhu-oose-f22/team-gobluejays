import UIKit
import JZCalendarWeekView

class DefaultViewModel: NSObject {

    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)

    // testing data
    lazy var events = [DefaultEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 1), location: "Melbourne",completed: true),
                       DefaultEvent(id: "1", title: "Two", startDate: secondDate, endDate: secondDate.add(component: .hour, value: 4), location: "Sydney",completed: false),
                       DefaultEvent(id: "2", title: "Three", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 2), location: "Tasmania",completed: true),
                       DefaultEvent(id: "3", title: "Four", startDate: thirdDate, endDate: thirdDate.add(component: .hour, value: 26), location: "Canberra",completed: false)]

    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)

    var currentSelectedData: OptionsSelectedData!
}
