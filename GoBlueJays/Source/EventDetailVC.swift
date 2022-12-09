import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import JZCalendarWeekView


class EventDetailVC: UIViewController {
    let db = Firestore.firestore()
    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
    lazy var event = AllDayEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 1), location: "Melbourne", isAllDay: false,completed: false,note:"None", type: 0, department: [])

  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var calendarWeekView = ((((UIApplication.shared.keyWindow?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).calendarWeekView
    
    var viewModel =  ((((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).viewModel

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = event.title
        location.text = event.location
        if #available(iOS 15.0, *) {
            startDate.text = event.startDate.formatted()
            endDate.text = event.endDate.formatted()
        } else {
            // Fallback on earlier versions
        }
        
        
        detail.text = event.note
        if event.completed {
            name.textColor = .gray
            name.attributedText = NSAttributedString(string: event.title, attributes: [NSAttributedString.Key.strikethroughStyle: 1])
        }
    }
    

    @IBAction func EditEvent(_ sender: UIButton) {
        let controller = EditEventViewController()
        controller.cell = self.event
        guard let currentscene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        guard let currentWindow = currentscene.window else { return }

        self.dismiss(animated: true){

            
            let navigationVC = UINavigationController(rootViewController: controller)
            (((currentWindow.rootViewController?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).present(navigationVC, animated: true, completion: nil)
            
            
        }
    }
    @IBAction func deleteEvent(_ sender: UIButton) {
        let curEvent = db.collection(CurrentLoginName.name).document("scheduleDayEvents").collection("events").document(event.id)
        //let curEvent = db.collection("scheduleDayEvents").document(event.id)
        curEvent.delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        

        //MARK: Update events
        viewModel.events.removeAll(where: {$0.id == event.id})
        viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: viewModel.events)

        calendarWeekView!.forceReload(reloadEvents: viewModel.eventsByDate)
        
        
        self.dismiss(animated: true)
//        _ = navigationController?.popViewController(animated: true)
        
    }


    
    @IBAction func markComplete(_ sender: UIButton) {
        let curEvent = db.collection(CurrentLoginName.name).document("scheduleDayEvents").collection("events").document(event.id)
        //let curEvent = db.collection("scheduleDayEvents").document(event.id)
        curEvent.updateData(["completed":!event.completed]){
            err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
        
        event.completed = !event.completed

        
        calendarWeekView!.forceReload(reloadEvents: viewModel.eventsByDate)

        self.dismiss(animated: true)
    }
    

}
