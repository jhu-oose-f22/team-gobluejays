import UIKit
import JZCalendarWeekView

class HourRowHeader: JZRowHeader {

    override func setupBasic() {
        // different dateFormat
        dateFormatter.dateFormat = "HH"
        lblTime.textColor = .orange
        lblTime.font = UIFont.systemFont(ofSize: 12)
    }

}
