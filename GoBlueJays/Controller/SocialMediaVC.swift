//
//  SocialMediaVC.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 10/7/22.
//

import Foundation
import UIKit

class SocialMediaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tabs: [Detail] = [
        Detail(title: "Instagram", link: "https://www.instagram.com/johnshopkinsu/?hl=en", icon: "instagram"),
        Detail(title: "Twitter", link: "https://twitter.com/JohnsHopkins?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor", icon: "twitter"),
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
        let webView:WebViewVC = WebViewVC()
        //webView.modalPresentationStyle = .fullScreen
        webView.link = urlString
        self.present(webView, animated: true, completion: nil)
    }
}
