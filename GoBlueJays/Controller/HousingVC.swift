//
//  HousingVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 10/7/22.
//

import Foundation
import UIKit

class HousingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tabs: [Detail] = [
        Detail(title: "On-Campus Housing", link: "https://studentaffairs.jhu.edu/community-living/university-housing/", icon: "studenthousing"),
        Detail(title: "First and Second Year Building Options", link: "https://studentaffairs.jhu.edu/community-living/university-housing/buildings-rates/", icon: "options"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        cell.label.text = tabs[indexPath.row].title
        cell.icon!.image = UIImage(named: tabs[indexPath.row].icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath.row)
        let urlString = tabs[indexPath.row].link
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url)
        }
    }
}
