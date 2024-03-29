//
//  CourseListVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/13/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class CourseListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tabs: [courseListCourse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: "cell")
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        cell.label.text = tabs[indexPath.row].name
        cell.icon!.image = UIImage(named: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                     print("Ok button tapped")
            
            let db = Firestore.firestore()
            let user = CurrentLoginName.name
            db.collection(user).document("scheduleCourses").collection("courses").document(self.tabs[indexPath.row].uuid).delete {
                err in
                    if let err = err {
                        print("Error removing course: \(err)")
                    } else {
                        print("Course successfully removed!")
                    }
                }
            self.reload()
            if #available(iOS 16.0, *) {
                var viewModel =  ((((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UIViewController)?.presentedViewController as? UITabBarController)?.viewControllers![1] as? UINavigationController)?.viewControllers[0] as! LongPressViewController).viewModel
                viewModel.reloadData()
            } else {
                // Fallback on earlier versions
            }
                })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)

    }
    
    // reload course list with data from database
    func reload() {
        let db = Firestore.firestore()
        let user = CurrentLoginName.name
        db.collection(user).document("scheduleCourses").collection("courses").getDocuments() {
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tabs = []
                // extract useful data and store as struct
                for document in QuerySnapshot!.documents {
                    let cn = document.data()["CourseNumber"] as? String
                    let s = document.data()["Section"] as? String
                    let name = cn! + "." + s! + "     (Delete)"
                    let uuid = document.data()["uuid"] as? String
                    self.tabs.append(courseListCourse(name: name, uuid: uuid!))
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

