//
//  AthleticsVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 10/7/22.
//

import Foundation
import UIKit

class AthleticsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tabs: [Detail] = [
        Detail(title: "Athletics Homepage", link: "https://hopkinssports.com/index.aspx", icon: "home"),
        Detail(title: "Teambuildr", link: "https://apps.apple.com/us/app/teambuildr-training/id1588729407", icon: "muscle"),
        Detail(title: "Sway Medical", link: "https://apps.apple.com/us/app/sway-medical/id657932025", icon: "medical"),
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

    // information list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IconCell
        cell.label.text = tabs[indexPath.row].title
        cell.icon!.image = UIImage(named: tabs[indexPath.row].icon)
        return cell
    }
    
    // popup window, handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let urlString = tabs[indexPath.row].link
        if (urlString == "https://hopkinssports.com/index.aspx") {
            let webView:WebViewVC = WebViewVC()
            webView.link = urlString
            self.present(webView, animated: true, completion: nil)
        } else if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
