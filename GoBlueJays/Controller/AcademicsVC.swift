//
//  AcademicsVC.swift
//  GoBlueJays
//
//  Created by Jessie Luo on 8/13/22.
//

import Foundation
import UIKit

class AcademicsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tabs: [Detail] = [
        Detail(title: "Overview", link: "https://www.jhu.edu", icon: "overview"),
        Detail(title: "Undergraduate Education", link: "https://www.jhu.edu/academics/undergraduate-studies/", icon: "undergrad"),
        Detail(title: "Graduate Education", link: "https://www.jhu.edu/academics/graduate-studies/", icon: "grad"),
        Detail(title: "Schools & Divisions", link: "https://www.jhu.edu/schools/", icon: "search"),
        Detail(title: "Programs & Majors", link: "https://e-catalogue.jhu.edu/programs/", icon: "study"),
        Detail(title: "Advanced Academic Programs", link: "https://advanced.jhu.edu", icon: "advanced"),
        Detail(title: "Study Abroad", link: "https://studyabroad.jhu.edu", icon: "globe"),
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
        let urlString = tabs[indexPath.row].link
        let webView:WebViewVC = WebViewVC()
        webView.link = urlString
        self.present(webView, animated: false, completion: nil)
    }
}
