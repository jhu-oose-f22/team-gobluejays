//
//  ActivityVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

protocol activityTableDelegate: AnyObject {
    func cellButtonPressed(actID: String)
}

class ActivityVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, activityTableDelegate {

    @IBOutlet weak var PageView: UIPageControl!
    @IBOutlet weak var recomCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var timer = Timer()
    var counter = 0
    
    var activities: [Activity] = []
    var filteredActivities: [Activity] = []
    var recact: [Activity] = [
        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics", likes:false, id:"act001"),
        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics", likes:false, id:"act002"),
        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing", likes:false, id:"act003"),
//        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage", likes:false),
//        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans", likes:false),
//        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media", likes:false),
//        Activity(title: "Activity 7", time: "October 26 2022", location: "Malone Hall 207", image:"social media", likes:false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Explore"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none

        searchBar.delegate = self
        
        recomCollection.delegate = self
        recomCollection.dataSource = self
        PageView.numberOfPages = recact.count
        PageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.recChange), userInfo: nil, repeats: true)
        }
        
        let db = Firestore.firestore()
        db.collection("activity").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    print(data)
                    let act:Activity = Activity(title: data["title"] as! String,
                                                time: data["time"] as! String,
                                                location: data["location"] as! String,
                                                image: data["image"] as! String,
                                                likes: data["likes"] as! Bool,
                                                id: document.documentID)
                    self.activities.append(act)
                }
            }
            filteredActivities = activities
            print("reload")
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredActivities.count % 2 == 0){
            return filteredActivities.count/2
        } else {
            return filteredActivities.count/2 + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        cell.delegate = self
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        var ids : [String] = []
        
        cell.location.text = filteredActivities[ind1].location
        cell.Title.text = filteredActivities[ind1].title
        cell.time.text = filteredActivities[ind1].time
        cell.ActivityImage.image = UIImage(named: filteredActivities[ind1].image)
        cell.button_configure(likes: filteredActivities[ind1].likes, but: 1)
        ids.append(filteredActivities[ind1].id)
        
        if (ind2 <= filteredActivities.count-1) {
            cell.ActivityBlock2.isHidden = false
            cell.location2.text = filteredActivities[ind2].location
            cell.Title2.text = filteredActivities[ind2].title
            cell.time2.text = filteredActivities[ind2].time
            cell.ActivityImage2.image = UIImage(named: filteredActivities[ind2].image)
            cell.button_configure(likes: filteredActivities[ind2].likes, but: 2)
            ids.append(filteredActivities[ind2].id)
        }
        else {
            cell.ActivityBlock2.isHidden = true
        }
        cell.assign_ID(ids: ids)
        cell.configure()
        return cell
    }
    
    func cellButtonPressed(actID: String) {
        print("delegate here")
        for (index, activity) in self.activities.enumerated() {
            if activity.id == actID {
                self.activities[index].likes = !self.activities[index].likes
            }
        }
        for (index, activity) in self.filteredActivities.enumerated() {
            if activity.id == actID {
                self.filteredActivities[index].likes = !self.filteredActivities[index].likes
            }
        }
        self.reloadData()
//        print("reloaded!")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: Search Bar Config
    // whenever there is text in the search bar, run the following code
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String) {
        
        self.filteredActivities = []
        
        if searchText == "" {
            self.filteredActivities = self.activities
        } else {
            for activity in self.activities {
                if activity.title.lowercased().contains(searchText.lowercased()) || activity.location.lowercased().contains(searchText.lowercased()) {
                    filteredActivities.append(activity)
                }
            }
        }
        print("reload!")
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    @objc func recChange() {
        if counter < recact.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.recomCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            PageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.recomCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            PageView.currentPage = counter
            counter = 1
        }
    }

}

extension ActivityVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recact.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomCell", for: indexPath) as! RecomCell
        let index = indexPath.row
        
        cell.configure()
        cell.location.text = recact[index].location
        cell.title.text = recact[index].title
        cell.time.text = recact[index].time
        cell.image.image = UIImage(named: recact[index].image)
        cell.rectext.text = "Near you!"
        
        return cell
    }
}

extension ActivityVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = recomCollection.frame.size
        return CGSize(width: size.width, height: size.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
