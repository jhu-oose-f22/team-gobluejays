//
//  CollectActivities.swift
//  GoBlueJays
//
//  Created by david on 10/17/22.

//

import UIKit
import FirebaseCore
import FirebaseFirestore

class CollectVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, activityTableDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    var collects: [Activity] = []
    var filteredCollects: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        // searchBar.delegate = self

        //navigationController?.navigationBar.tintColor = .accentColor
        
        let db = Firestore.firestore()
        db.collection("activity").getDocuments(){ [self]
            (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM dd, yyyy hh:mm a"
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    let timep = data["timestamp"] as! Timestamp
                    let timec = formatter.string(from: timep.dateValue())
                    
                    if (data["likes"] as! Bool == true) {
                        let act:Activity = Activity(title: data["title"] as! String,
                                                    time: timec,
                                                    location: data["location"] as! String,
                                                    image: data["imageLink"] as! String,
                                                    likes: data["likes"] as! Bool,
                                                    id: document.documentID,
                                                    category: data["category"] as! String,
                                                    tags: (data["tags"] as! NSArray) as! [String])
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        cell.delegate = self
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        var ids : [String] = []

        cell.location.text = filteredCollects[ind1].location
        cell.Title.text = filteredCollects[ind1].title
        cell.time.text = filteredCollects[ind1].time
        // cell.ActivityImage.image = UIImage(named: filteredCollects[ind1].image)
        // cell.loadImageFrom(urlAddress: filteredCollects[ind1].image, right: true)
        let url1 = URL(string: filteredCollects[ind1].image)
        cell.ActivityImage.kf.setImage(with: url1)
        cell.collect.isHidden = true
        
        if (ind2 <= filteredCollects.count-1) {
            cell.img2.isHidden = false
            cell.whiteback2.isHidden = false
            cell.location2.text = filteredCollects[ind2].location
            cell.Title2.text = filteredCollects[ind2].title
            cell.time2.text = filteredCollects[ind2].time
            // cell.ActivityImage2.image = UIImage(named: filteredCollects[ind2].image)
            // cell.loadImageFrom(urlAddress: filteredCollects[ind2].image, right: false)
            let url2 = URL(string: filteredCollects[ind2].image)
            cell.ActivityImage2.kf.setImage(with: url2)
            ids.append(filteredCollects[ind2].id)
            cell.collect2.isHidden = true
        }
        else {
            cell.img2.isHidden = true
            cell.whiteback2.isHidden = true
        }
        
        cell.configure()
        return cell
    }

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
            searchController.searchBar.selectedScopeButtonIndex != 0
          return (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func filterContentForSearchText(searchText: String, scopeButton: String = "All") {
        if isFiltering {
            filteredCollects = collects.filter {
                collect in
                if isSearchBarEmpty {
                    let scopeMatch = (scopeButton == "All" || collect.category.lowercased().contains(scopeButton.lowercased()))
                    return scopeMatch
                } else {
                    let scopeMatch = (scopeButton == "All" || collect.category.lowercased().contains(scopeButton.lowercased()))
                    let searchTextMatch = collect.title.lowercased().contains(searchText.lowercased())
                    return scopeMatch && searchTextMatch
                }
            }
        } else {
            filteredCollects = collects
        }
        self.tableView.reloadData()
    }
    
    func cellButtonPressed(actID: String) {
    }
    
    func cellTapped(act: ActivityDetailModel) {
        print("got to here")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityDetailView") as! ActivityDetail
        vc.activity = act
        self.present(vc, animated: true, completion: nil)
    }

}
extension CollectVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
      let searchText = searchBar.text!
      filterContentForSearchText(searchText: searchText, scopeButton: scopeButton)
  }
}


