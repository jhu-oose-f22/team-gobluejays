//
//  ActivityCell.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/7/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ActivityCell: UITableViewCell{
    weak var delegate: activityTableDelegate?
    
    @IBOutlet weak var ActivityImage: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var collect: UIButton!
    @IBOutlet weak var back: UIView!
    
    @IBOutlet weak var locicon2: UIImageView!
    
    @IBOutlet weak var img2: UIButton!
    @IBOutlet weak var whiteback2: UIView!
    @IBOutlet weak var timeicon2: UIImageView!
    @IBOutlet weak var Title2: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var collect2: UIButton!
    @IBOutlet weak var location2: UILabel!
    @IBOutlet weak var ActivityImage2: UIImageView!
    @IBOutlet weak var back2: UIView!
    @IBOutlet weak var ActivityBlock2: UIView!
    
    var activityID: [String] = []
    
    @IBAction func cell1_tap(_ sender: UIButton) {
        let act = ActivityDetailModel(title: Title.text ?? "No Title", date: "Temp", time: time.text ?? "No Time", location: location.text ?? "No Location", host: "Temp", cost: "Temp", detail: "Temp", image: ActivityImage.asImage())
        self.delegate!.cellTapped(act: act)
    }
    
    @IBAction func cell2_tap(_ send: UIButton) {
        let act = ActivityDetailModel(title: Title2.text ?? "temp", date: "Temp", time: time2.text ?? "temp", location: location2.text ?? "temp", host: "Temp", cost: "Temp", detail: "Temp", image: ActivityImage2.asImage())
        self.delegate!.cellTapped(act: act)
    }
    
    @IBAction func likes_click(_ sender: UIButton) {
        print(activityID)
        let db = Firestore.firestore()
        if collect.tag == 0 {
            button_configure(likes: true, but: 1)
            db.collection("activity").document(activityID[0]).updateData(["likes" : true])
            print("liked")
        } else {
            button_configure(likes: false, but: 1)
            db.collection("activity").document(activityID[0]).updateData(["likes" : false])
            print("unliked")
        }
        delegate?.cellButtonPressed(actID: activityID[0])
    }
    
    @IBAction func likes_click2(_ sender: UIButton) {
        let db = Firestore.firestore()
        if collect2.tag == 0 {
            button_configure(likes: true, but: 2)
            db.collection("activity").document(activityID[1]).updateData(["likes" : true])
        } else {
            button_configure(likes: false, but: 2)
            db.collection("activity").document(activityID[1]).updateData(["likes" : false])
        }
        delegate?.cellButtonPressed(actID: activityID[1])
    }
    
    func configure() {
        collect.setTitle("", for: .normal)
        collect.imageView?.contentMode = .scaleAspectFit
        collect2.setTitle("", for: .normal)
        collect2.imageView?.contentMode = .scaleAspectFit
        
        ActivityImage.layer.cornerRadius = 5
        ActivityImage.clipsToBounds = true
        ActivityImage2.layer.cornerRadius = 5
        ActivityImage2.clipsToBounds = true
        
        back.layer.cornerRadius = 5
        back.clipsToBounds = true
        back2.layer.cornerRadius = 5
        back2.clipsToBounds = true
    }
    
    func button_configure(likes: Bool, but: Int) {
        if likes == true {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            if but == 1 {
                collect.setImage(image, for: .normal)
                collect.tintColor = .red
                collect.tag = 1
            } else {
                collect2.setImage(image, for: .normal)
                collect2.tintColor = .red
                collect2.tag = 1
            }
        } else {
            let config = UIImage.SymbolConfiguration(scale: .medium)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            if but == 1 {
                collect.setImage(image, for: .normal)
                collect.tintColor = .lightGray
                collect.tag = 0
            } else {
                collect2.setImage(image, for: .normal)
                collect2.tintColor = .lightGray
                collect2.tag = 0
            }
        }
    }
    
    func assign_ID(ids: [String]) {
        activityID = ids
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collect.setTitleColor(.link, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
