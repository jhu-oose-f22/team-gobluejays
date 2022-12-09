import UIKit
import JZCalendarWeekView

// If you want to use Move Type LongPressWeekView, you have to inherit from JZLongPressEventCell and update event when you configure cell every time
class LongPressEventCell: JZLongPressEventCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    var borderColor:UIColor! = UIColor(hex: 0x0899FF)
    var contentColor:UIColor! = UIColor(hex: 0xEEF7FF)

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBasic()
        // You have to set the background color in contentView instead of cell background color, because cell reuse problems in collectionview
        // When setting alpha to cell, the alpha will back to 1 when collectionview scrolled, which means that moving cell will not be translucent
        self.contentView.backgroundColor = contentColor
    }

    // basic UI styling
    func setupBasic() {
        self.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        borderView.backgroundColor = borderColor
    }

    // schedule event/course info display styling
    func configureCell(event: AllDayEvent, isAllDay: Bool = false) {
        self.event = event
        locationLabel.text = event.location
        titleLabel.text = event.title
        locationLabel.isHidden = isAllDay
        // Course
        if event.type == 1{
            contentColor = UIColor(hex: 0xDEF5E5)
            borderColor = UIColor(hex: 0x8EC3B0)
            borderView.backgroundColor = borderColor
            self.contentView.backgroundColor = contentColor
            titleLabel.font = UIFont.systemFont(ofSize: 8, weight: .medium)
            locationLabel.font = UIFont.systemFont(ofSize: 8, weight: .light)
        }
        //Events
        else if event.completed {
            
            contentColor = UIColor(hex: 0xfff1ee)
            borderColor = UIColor(hex: 0xe06560)
            borderView.backgroundColor = borderColor
            self.contentView.backgroundColor = contentColor
            locationLabel.text = event.note
            locationLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
        else{
            contentColor = UIColor(hex: 0xEEF7FF)
            borderColor = UIColor(hex: 0x0899FF)
            borderView.backgroundColor = borderColor
            self.contentView.backgroundColor = contentColor
            locationLabel.text = event.note
            locationLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }

}
