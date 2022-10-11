//
//  CollectVC.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/10/22.
//

import UIKit

class CollectVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var collects: [Activity] = [
        Activity(title: "Activity 1", time: "October 20 2022", location: "Malone Hall 201", image:"athletics"),
        Activity(title: "Activity 2", time: "October 21 2022", location: "Malone Hall 202", image:"academics"),
        Activity(title: "Activity 3", time: "October 22 2022", location: "Malone Hall 203", image:"housing"),
        Activity(title: "Activity 4", time: "October 23 2022", location: "Malone Hall 204", image:"frontpage"),
        Activity(title: "Activity 5", time: "October 24 2022", location: "Malone Hall 205", image:"Nolans"),
        Activity(title: "Activity 6", time: "October 25 2022", location: "Malone Hall 206", image:"social media"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:"ActivityCell", bundle: .main), forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .none
        
        //navigationController?.navigationBar.tintColor = .accentColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collects.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityCell", for:indexPath) as! ActivityCell
        
        let ind1 = indexPath.row * 2
        let ind2 = indexPath.row * 2 + 1
        
        cell.location.text = collects[ind1].location
        cell.Title.text = collects[ind1].title
        cell.time.text = collects[ind1].time
        cell.ActivityImage.image = UIImage(named: collects[ind1].image)
        
        if (ind2 <= collects.count-1) {
            cell.location2.text = collects[ind2].location
            cell.Title2.text = collects[ind2].title
            cell.time2.text = collects[ind2].time
            cell.ActivityImage2.image = UIImage(named: collects[ind2].image)
        }
        else {
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
