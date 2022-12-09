//
//  CollectActivities.swift
//  GoBlueJays
//
//  Created by david on 10/17/22.

//

import UIKit
import FirebaseCore
import FirebaseFirestore
import SwiftSoup

protocol collectToMainDelegate: AnyObject {
    func uncollect(actID: String)
}

class CollectVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, activityTableDelegate {

    // setup search result vc
    let searchController = UISearchController(searchResultsController: nil)
    weak var delegate: collectToMainDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var collects: [Activity] = []
    var filteredCollects: [Activity] = []
    
    var default_images = [
        "https://static1.campusgroups.com/upload/jhu/2022/r3_image_upload_1382318_gilman360x240jpg_62919654.jpeg",
        "https://static1.campusgroups.com/upload/jhu/2020/r2_image_upload_1367200_JHU_Frontjpg_7162189.jpeg",
        "https://static1.campusgroups.com/upload/jhu/2021/r3_image_upload_1918390_Apple_thumbnail_117213433.png"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none
        
        // search bar config
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none

        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let db = Firestore.firestore()
        db.collection(CurrentLoginName.name).document("activity").collection("act").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    if (data["likes"] as! Bool == true) && (document.documentID.count > 6){
                        let act:Activity = Activity(title: data["title"] as! String,
                                                    time: data["timestamp"] as! String,
                                                    location: data["location"] as! String,
                                                    image: data["imageLink"] as! String,
                                                    likes: data["likes"] as! Bool,
                                                    id: document.documentID,
                                                    category: data["category"] as! String,
                                                    host: data["host"] as! String,
                                                    cost: data["cost"] as! String,
                                                    detail: data["detail"] as! String)
                        self.collects.append(act)
                    }
                }
            }
            filteredCollects = collects
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredCollects.count % 2 == 0){
            return filteredCollects.count/2
        } else {
            return filteredCollects.count/2 + 1
        }
    }
    
    // selected cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        cell.delegate = self
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        var ids : [String] = []

        // fill data
        cell.location.text = filteredCollects[ind1].location
        cell.Title.text = filteredCollects[ind1].title
        cell.time.text = filteredCollects[ind1].time
        let url = URL(string: filteredCollects[ind1].image)
        if let url = url {
            let group = DispatchGroup()
            group.enter()
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    do {
                        let data = String(data: data, encoding: .utf8)
                        if let data = data {
                            let doc = try SwiftSoup.parse(data)
                            let image_url = try
                            doc.getElementsByClass("img-responsive").first()
                            if let image_url = image_url {
                                try self.filteredCollects[ind1].image = image_url.attr("src")
                            } else {
                                self.filteredCollects[ind1].image = self.default_images[Int.random(in: 0..<3)]
                            }
                        } else {
                            self.filteredCollects[ind1].image = self.default_images[Int.random(in: 0..<3)]
                        }
                    } catch {}
                    group.leave()
                }
            }
            DispatchQueue.global().async {
                task.resume()
            }
            group.wait()
        } else {
            self.filteredCollects[ind1].image = self.default_images[Int.random(in: 0..<3)]
        }
        
        let url1 = URL(string: filteredCollects[ind1].image)
        cell.ActivityImage.kf.setImage(with: url1)
        cell.button_configure(likes: filteredCollects[ind1].likes, but: 1)
        ids.append(filteredCollects[ind1].id)
        
        // assign value if within range
        if (ind2 <= filteredCollects.count-1) {
            let url = URL(string: filteredCollects[ind2].image)
            if let url = url {
                let group = DispatchGroup()
                group.enter()
                let task = URLSession.shared.dataTask(with: url) {
                    (data, response, error) in
                    if let data = data {
                        do {
                            let data = String(data: data, encoding: .utf8)
                            if let data = data {
                                let doc = try SwiftSoup.parse(data)
                                let image_url = try
                                doc.getElementsByClass("img-responsive").first()
                                if let image_url = image_url {
                                    try self.filteredCollects[ind2].image = image_url.attr("src")
                                } else {
                                    self.filteredCollects[ind2].image = self.default_images[Int.random(in: 0..<3)]
                                }
                            } else {
                                self.filteredCollects[ind2].image = self.default_images[Int.random(in: 0..<3)]
                            }
                        } catch {}
                        group.leave()
                    }
                }
                DispatchQueue.global().async {
                    task.resume()
                }
                group.wait()
            } else {
                self.filteredCollects[ind2].image = self.default_images[Int.random(in: 0..<3)]
            }
            cell.img2.isHidden = false
            cell.whiteback2.isHidden = false
            cell.location2.text = filteredCollects[ind2].location
            cell.Title2.text = filteredCollects[ind2].title
            cell.time2.text = filteredCollects[ind2].time
            let url2 = URL(string: filteredCollects[ind2].image)
            cell.ActivityImage2.kf.setImage(with: url2)
            ids.append(filteredCollects[ind2].id)
            cell.button_configure(likes: filteredCollects[ind2].likes, but: 2)
        }
        else {
            cell.img2.isHidden = true
            cell.whiteback2.isHidden = true
        }
        
        cell.configure()
        cell.assign_ID(ids: ids)
        return cell
    }

    // search bar empty
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    // return filter status
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
          return (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    // reload result when search
    func filterContentForSearchText(searchText: String) {
        if isFiltering {
            if collects.isEmpty {
                let alert = UIAlertController(title: "Alert", message: "You haven't liked anything yet!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert,animated:true)
            }
            filteredCollects = collects.filter {
                collect in
                    let searchTextMatch = collect.title.lowercased().contains(searchText.lowercased())
                return searchTextMatch
            }
        } else {
            filteredCollects = collects
        }
        self.tableView.reloadData()
    }
    
    // view activity info when press on cell
    func cellButtonPressed(actID: String) {
        delegate?.uncollect(actID: actID)
        let db = Firestore.firestore()
        for (index, activity) in self.collects.enumerated() {
            if activity.id == actID {
                if activity.likes == false {
                    db.collection(CurrentLoginName.name).document("activity").collection("act").document(actID).setData([
                        "category": activity.category,
                        "image": activity.image,
                        "imageLink": "",
                        "likes": true,
                        "location":activity.location,
                        "timestamp":activity.time,
                        "title":activity.title,
                        "host":activity.host,
                        "cost":activity.cost,
                        "detail":activity.detail
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                } else {
                    db.collection(CurrentLoginName.name).document("activity").collection("act").document(actID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
                self.collects[index].likes = !self.collects[index].likes
            }
        }
        
        // reload add num
        for (index, activity) in self.filteredCollects.enumerated() {
            if activity.id == actID {
                self.filteredCollects[index].likes = !self.filteredCollects[index].likes
            }
        }
        
        self.tableView.reloadData()
    }
    
    // tap cell reaction
    func cellTapped(act: ActivityDetailModel, actID: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetail
        
        var actdetail = act
        for a in self.collects {
            if a.id == actID {
                let tarr = a.time.components(separatedBy: " ")
                actdetail.date = tarr[0]
                actdetail.time = tarr[1]
                actdetail.host = a.host
                actdetail.detail = a.detail
                actdetail.cost = a.cost
                
                vc.activity = actdetail
            }
        }
        
        self.present(vc, animated: true, completion: nil)
    }

}

// handle search result update
extension CollectVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      let searchText = searchBar.text!
      filterContentForSearchText(searchText: searchText)
  }
}


