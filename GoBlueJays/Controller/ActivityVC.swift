//
//  ActivityVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit

class ActivityVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activities: [Activity] = [
        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics", likes:false),
        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics", likes:false),
        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing", likes:false),
        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage", likes:false),
        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans", likes:false),
        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media", likes:false),
        Activity(title: "Activity 7", time: "October 26 2022", location: "Malone Hall 207", image:"social media", likes:false),
    ]
    
    var filteredActivities: [Activity]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Explore"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
        
        filteredActivities = activities
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
        
        cell.location.text = filteredActivities[ind1].location
        cell.Title.text = filteredActivities[ind1].title
        cell.time.text = filteredActivities[ind1].time
        cell.ActivityImage.image = UIImage(named: filteredActivities[ind1].image)
        
        if (ind2 <= filteredActivities.count-1) {
            cell.ActivityBlock2.isHidden = false
            cell.location2.text = filteredActivities[ind2].location
            cell.Title2.text = filteredActivities[ind2].title
            cell.time2.text = filteredActivities[ind2].time
            cell.ActivityImage2.image = UIImage(named: filteredActivities[ind2].image)
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
    
    // MARK: Search Bar Config
    // whenever there is text in the search bar, run the following code
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String) {
        
        filteredActivities = []
        if searchText == "" {
            filteredActivities = activities
        } else {
            for activity in activities {
                if activity.title.lowercased().contains(searchText.lowercased()) {
                    filteredActivities.append(activity)
                }
            }
        }
        self.tableView.reloadData()
    }

}
