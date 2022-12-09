//
//  ActivityDetail.swift
//  GoBlueJays
//
//  Created by Thomas Yu on 11/4/22.
//

import Foundation
import UIKit

class ActivityDetail: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    lazy var activity = ActivityDetailModel(title: "1", date: "1", time: "1", location: "1", host: "1", cost: "1", detail: "1", image: UIImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill data to storyboard
        name.text = activity.title
        date.text = date.text! + activity.date
        time.text = time.text! + activity.time
        location.text = location.text! + activity.location
        host.text = host.text! + activity.host
        cost.text = cost.text! + activity.cost
        detail.text = activity.detail
        img.image = activity.image
    }
}
