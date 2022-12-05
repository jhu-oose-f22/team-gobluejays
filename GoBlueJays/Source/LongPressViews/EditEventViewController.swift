//
//  EditEventViewController.swift
//  AdvancedCalendar
//
//  Created by Kaia Gao on 11/25/22.
//

import UIKit
import JZCalendarWeekView
import FirebaseCore
import FirebaseFirestore

class EditEventViewController: UIViewController {
    let db = Firestore.firestore()
    var cell:AllDayEvent!

    
    lazy var calendarWeekView = ((((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).calendarWeekView
    
    lazy var viewModel =  ((((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).viewModel
    
    let doneBtn = UIButton(type: .close)
    
    let settingTable:UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(checkBtnTableViewCell.self, forCellReuseIdentifier: checkBtnTableViewCell.className)
        tableView.register(EditDetailTableViewCell.self, forCellReuseIdentifier: EditDetailTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBasic()
        // Load in Table
        settingTable.delegate = self
        settingTable.dataSource = self
        
    }
    
    /// Set up navigation bar
    func setupBasic() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(settingTable)
        
        // Navigation Bar
        navigationItem.title = "Edit"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onBtnDoneTapped))
        navigationController?.navigationBar.tintColor = .systemGray
        
        let playButtonConstraints = [
//            doneBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
//            doneBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            doneBtn.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingTable.frame = view.bounds
    }
    
    @objc func onBtnDoneTapped(){
        if let event:AllDayEvent = self.cell{
            let curEvent = self.db.collection("scheduleDayEvents").document(event.id)
            let keyedValues:[String:Any] = ["title":event.title,
                                            "completed":event.completed,
                                            "startDate":event.startDate,
                                            "endDate": event.endDate,
                                            "location":event.location,
                                            "isAllDay":false,
                                            "note":event.note]
            
            
            curEvent.updateData(keyedValues){err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.viewModel.events[self.viewModel.events.firstIndex(where: {$0.id == event.id})!] = event.copy() as! AllDayEvent
                        self.viewModel.eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents:  self.viewModel.events)
                        self.calendarWeekView!.forceReload(reloadEvents: self.viewModel.eventsByDate)
//                        let _ = AllDayViewModel()
                    }
            }
            
        }
        


        

        self.dismiss(animated: true)
    }

   
}

extension EditEventViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 100
        }
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditDetailTableViewCell.className, for: indexPath) as? EditDetailTableViewCell else {
                return UITableViewCell()
            }
        
        switch indexPath.row{
        case 0:
            cell.updateCell(title: "Title", textField: self.cell?.title ?? "Undefined", cell: self.cell!)
        case 1:
            if #available(iOS 15.0, *) {
                cell.updateCell(title: "Start", textField: self.cell?.startDate.formatted() ?? "", cell: self.cell!)
            } else {
                // Fallback on earlier versions
            }
        case 2:
            if #available(iOS 15.0, *) {
                cell.updateCell(title: "End", textField: self.cell?.endDate.formatted() ?? "", cell: self.cell!)
            } else {
                // Fallback on earlier versions
            }
        case 3:
            cell.updateCell(title: "Complete", textField: "\(self.cell?.completed ?? false)",cell: self.cell!)
        case 4:
            cell.updateCell(title: "Note", textField: self.cell?.note ?? "", cell: self.cell!)
        case 5:
            cell.updateCell(title: "Location", textField: self.cell?.location ?? "undefined", cell: self.cell!)
        default:
            return UITableViewCell()
        }

            return cell
    }
    
    
    
    
}
