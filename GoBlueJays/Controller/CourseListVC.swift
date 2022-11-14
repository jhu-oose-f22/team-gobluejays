//
//  CourseListVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/13/22.
//

import UIKit

class CourseListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tabs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: "cell")
        //FOR LOOP TO ITERATE THROUGH THE ARRAY AND PUT INTO TABS
        
        for rc in ScheduleVC.registeredCourses {
            tabs.append(rc.courseNumber + "." + rc.section)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        cell.label.text = tabs[indexPath.row]
        cell.icon!.image = UIImage(named: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
        //***THIS IS WHERE WE CAN DELETE THE COURSE FROM THE ARRAY***
        
        //could create a pop up that asks for comfirmation to delete the course
        
        //Trying to delete the item not working right now
        /*
        ScheduleVC.registeredCourses.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with:
         */
    }
}

