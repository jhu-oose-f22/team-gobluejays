//
//  RecomCell.swift
//  GoBlueJays
//
//  Created by 刘忻岩 on 10/28/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class RecomCell: UICollectionViewCell {
    
    weak var delegate: activityTableDelegate?
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var recbar: UIView!
    @IBOutlet weak var rectext: UILabel!
    @IBOutlet weak var collect: UIButton!
    
    var activityID: String = ""
    
    @IBAction func likes_click(_ sender: UIButton) {
        if collect.tag == 0 {
            button_configure(likes: true)
            print("liked")
        } else {
            button_configure(likes: false)
            print("unliked")
        }
        delegate?.cellButtonPressed(actID: activityID)
    }
    
    func assign_ID(id: String) {
        activityID = id
    }
    
    func configure() {
        background.layer.cornerRadius = 5
        background.clipsToBounds = true
        recbar.layer.cornerRadius = 3
        recbar.clipsToBounds = true
        
        collect.setTitle("", for: .normal)
        collect.imageView?.contentMode = .scaleAspectFit
    }
    
    func button_configure(likes: Bool) {
        if likes == true {
            let config = UIImage.SymbolConfiguration(scale: .small)
            let image = UIImage(systemName: "heart.fill", withConfiguration: config)
            
            collect.setImage(image, for: .normal)
            collect.tintColor = .red
            collect.tag = 1
        } else {
            let config = UIImage.SymbolConfiguration(scale: .small)
            let image = UIImage(systemName: "heart", withConfiguration: config)
            
            collect.setImage(image, for: .normal)
            collect.tintColor = .lightGray
            collect.tag = 0
        }
    }
    
}
