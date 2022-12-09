import UIKit
import JZCalendarWeekView

class DefaultWeekView: JZBaseWeekView {

    override func registerViewClasses() {
        super.registerViewClasses()

        self.collectionView.register(UINib(nibName: EventCell.className, bundle: nil), forCellWithReuseIdentifier: EventCell.className)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as? EventCell,
            let event = getCurrentEvent(with: indexPath) as? DefaultEvent {
            cell.configureCell(event: event)
            return cell
        }
        preconditionFailure("EventCell and DefaultEvent should be casted")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedEvent = getCurrentEvent(with: indexPath) as? DefaultEvent {
            ToastUtil.toastMessageInTheMiddle(message: selectedEvent.title)
        }
    }
}
