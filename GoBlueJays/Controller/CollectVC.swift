//
//  CollectVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/10/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class CollectVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
//    var collects: [Activity] = [
//        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics", likes:false, id: "1"),
//        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics", likes:false, id: "1"),
//        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing", likes:false, id: "1"),
//        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage", likes:false, id: "1"),
//        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans", likes:false, id: "1"),
//        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media", likes:false, id: "1"),
//    ]
    var collects: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none
        
        //navigationController?.navigationBar.tintColor = .accentColor
        
        let db = Firestore.firestore()
        db.collection("activity").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    if (data["likes"] as! Bool == true) {
                        let act:Activity = Activity(title: data["title"] as! String,
                                                    time: data["time"] as! String,
                                                    location: data["location"] as! String,
                                                    image: data["image"] as! String,
                                                    likes: data["likes"] as! Bool,
                                                    id: document.documentID)
                        self.collects.append(act)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (collects.count % 2 == 0){
            return collects.count/2
        } else {
            return collects.count/2 + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        
        cell.location.text = collects[ind1].location
        cell.Title.text = collects[ind1].title
        cell.time.text = collects[ind1].time
        cell.ActivityImage.image = UIImage(named: collects[ind1].image)
        cell.collect.isHidden = true
        
        if (ind2 <= collects.count-1) {
            cell.location2.text = collects[ind2].location
            cell.Title2.text = collects[ind2].title
            cell.time2.text = collects[ind2].time
            cell.ActivityImage2.image = UIImage(named: collects[ind2].image)
            cell.collect2.isHidden = true
        }
        else {
            cell.ActivityBlock2.isHidden = true
        }
        
        cell.configure()
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
