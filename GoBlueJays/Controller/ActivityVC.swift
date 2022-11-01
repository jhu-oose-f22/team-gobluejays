//
//  ActivityVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class ActivityVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
//    var activities: [Activity] = [
//        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics", likes:false, id: "1"),
//        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics", likes:false, id: "1"),
//        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing", likes:false, id: "1"),
//        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage", likes:false, id: "1"),
//        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans", likes:false, id: "1"),
//        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media", likes:false, id: "1"),
//        Activity(title: "Activity 7", time: "October 26 2022", location: "Malone Hall 207", image:"social media", likes:false, id: "1"),
//    ]
    var activities: [Activity] = []
    var filteredActivities: [Activity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Explore"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none

        // search bar config
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["All", "Sports", "Academics", "Life"]
        searchController.searchBar.delegate = self
        definesPresentationContext = true

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
                                                id: document.documentID,
                                                category: data["category"] as! String)
                    self.activities.append(act)
                }
            }
            filteredActivities = activities
            tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // Old Search Bar Config
    // whenever there is text in the search bar, run the following code
//    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String) {
//
//        filteredActivities = []
//        if searchText == "" {
//            filteredActivities = activities
//        } else {
//            for activity in activities {
//                if activity.title.lowercased().contains(searchText.lowercased()) || activity.location.lowercased().contains(searchText.lowercased()) {
//                    filteredActivities.append(activity)
//                }
//            }
//        }
//        self.tableView.reloadData()
//    }
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
          return searchController.isActive &&
            (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func filterContentForSearchText(searchText: String, scopeButton: String = "All") {
        if isFiltering {
            filteredActivities = activities.filter { (activity: Activity) -> Bool in
                if isSearchBarEmpty {
                    let scopeMatch = (scopeButton == "All" || activity.category.lowercased().contains(scopeButton.lowercased()))
                    return scopeMatch
                } else {
                    let scopeMatch = (scopeButton == "All" || activity.category.lowercased().contains(scopeButton.lowercased()))
                    let searchTextMatch = activity.title.lowercased().contains(searchText.lowercased())
                    return scopeMatch && searchTextMatch
                }
            }
        } else {
            filteredActivities = activities
        }
      
        self.tableView.reloadData()
    }

}
extension ActivityVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
      let searchText = searchBar.text!
      filterContentForSearchText(searchText: searchText, scopeButton: scopeButton)
  }
}
