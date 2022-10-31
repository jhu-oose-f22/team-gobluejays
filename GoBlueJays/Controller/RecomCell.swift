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
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var recbar: UIView!
    @IBOutlet weak var rectext: UILabel!
    
    func configure() {
        background.layer.cornerRadius = 5
        background.clipsToBounds = true
        recbar.layer.cornerRadius = 3
        recbar.clipsToBounds = true
    }
    
}
