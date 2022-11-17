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
            db.collection("scheduleCourses").document(self.tabs[indexPath.row].uuid).delete {
                err in
                    if let err = err {
                        print("Error removing course: \(err)")
                    } else {
                        print("Course successfully removed!")
                    }
                }
            self.reload()
                })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)

    }
    
    func reload() {
        let db = Firestore.firestore()
        db.collection("scheduleCourses").getDocuments() {
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tabs = []
                for document in QuerySnapshot!.documents {
                    let cn = document.data()["CourseNumber"] as? String
                    let s = document.data()["Section"] as? String
                    //self.tabs.append(cn! + "." + s! + "     (Delete)")
                    let name = cn! + "." + s! + "     (Delete)"
                    let uuid = document.data()["uuid"] as? String
                    self.tabs.append(courseListCourse(name: name, uuid: uuid!))
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

