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
        Detail(title: "Off-Campus Housing", link: "https://offcampushousing.jhu.edu/", icon: "offcampus"),
        Detail(title: "Nine East", link: "https://nineeast33rd.com/", icon: "9east"),
        Detail(title: "Academy on Charles", link: "https://www.theacademyoncharles.com/", icon: "academy"),
        Detail(title: "2022-2023 Rates", link: "https://studentaffairs.jhu.edu/community-living/wp-content/uploads/sites/20/2022/03/2022-2023-Room-Board-Rates.pdf", icon: "rates"),
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
